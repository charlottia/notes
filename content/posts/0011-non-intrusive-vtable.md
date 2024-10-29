---
title: Non-intrusive vtable
created_at: 2024-10-29T18:07:00+1100
kind: article
description: >-
  OOP is the world's most consistently-used term in any field of any kind, ever.
---

<section id="top">

```zig
const Control = union(enum) {
    button: *Controls.Button,
    menubar: *Controls.Menubar,
    menu: *Controls.Menu,
    menu_item: *Controls.MenuItem,
    editor: *Controls.Editor,

    fn generation(self: Control) usize {
        switch (self) {
            inline else => |c| return c.generation,
        }
    }

    fn setGeneration(self: Control, n: usize) void {
        switch (self) {
            inline else => |c| c.generation = n,
        }
    }

    fn deinit(self: Control) void {
        switch (self) {
            inline else => |c| c.deinit(),
        }
    }
};
```

I'm calling this thing a "non-intrusive vtable". A brief description for the
less familiar with Zig.

In short, we have a tagged union, `Control`, that can store a pointer to one
of the `Controls` types listed. Because it's a [tagged union], the variable
itself stores both the pointer as well as a "tag" value indicating which of the
variants is being stored, so there's no type confusion.

(One of these is unfortunately still 16 bytes on 64-bit systems: the tag,
which could theoretically be stored in 3 bits, nonetheless has a full 64 bits
allocated to it, because the payload that follows is a pointer, which must be
aligned. ¯\\\_(ツ)\_/¯)

In regular Zig code you can `switch` on the value to get at the payload:

```zig
var b: *Controls.Button = undefined;  // pretend we have one
var c: Control = .{ .button = b };

switch (c) {
    .button => |p| {
        // this branch will run, with p == b.
    },
    .menubar => |mb| {
        // won't run in this case, but you get the idea.
    },
    else => {
        // mandatory default if all cases aren't handled explicitly!
    },
}
```

Now, these `Controls` types all carry a `generation: usize` member. One way of
getting the generation of an arbitrary `Control` would be this:

```zig
fn getControlGeneration(c: Control) usize {
    return switch (c) {
        .button => |b| b.generation,
        .menubar => |mb| mb.generation,
        .menu => |m| m.generation,
        .menu_item => |mi| mi.generation,
        .editor => |e| e.generation,
    };
}
```

This works fine, and is probably optimal. But what's even more optimal is letting
comptime do the codegen for you. Returning to the definition above, we find:

```zig

    fn generation(self: Control) usize {
        return switch (self) {
            inline else => |c| c.generation,
        };
    }
```

[`inline else`] is `inline` in the same way [`inline for`] and [`inline while`]
are. For every unhandled case, a prong is unrolled. This means the body must
compile for each possible capture (i.e. each payload type). (You can of course
do comptime calls here, to do different things with different kinds of payloads,
though please consider your complexity budget!)

In this way, we create dispatch functions that encode the knowledge of (biggest air
quotes in the world) "all their subtypes' implementations". Ha ha ha.

</section>

<section id="aside-on-tags">

### Aside on tags

As a kind-of-side, another neat thing Zig affords when working with tagged
unions is call-site ergonomics when passing them to and from functions.

We have `Control`s stored in a hashmap with a string lookup. Here's a first
version of a "get control by ID" function:

```zig
fn controlById(id: []const u8) ?Control {
    return controls.get(id);
}
```

Too easy. But now using it looks like this:

```zig
fn render() {
    if (controlById("menubar")) |c| {
        const mb = c.menubar; // <-- safety-checked variant assertion
        // mb has type *Controls.Menubar.
    }
    // ...
}
```

And indeed, most actual uses will probably need an intermediate, since most
call-sites will actually know the type of what they're asking for. Why not
instead roll that into the getter?

```zig
fn controlById(
    comptime tag: std.meta.Tag(Control),
    id: []const u8,
) ?std.meta.TagPayload(Control, tag) {
    const c = self.controls.get(id) orelse return null;
    return @field(c, @tagName(tag));
}
```

[`std.meta.Tag(Control)`][`std.meta.Tag`] gets the type of the "tag" type of the
given type. What a mouthful. In other words, `Control` is a tagged union, and
the tag is the implicitly-defined enum that represents which variant is chosen.
For `Control`, that enum takes the values `.button`, `.menubar`, `.menu`, etc.

We take the expected tag of `Control` at comptime, and declare our return type
to be (the optional of) the payload in `Control` that corresponds to `tag`,
using [`std.meta.TagPayload(Control, tag)`][`std.meta.TagPayload`]. So a call
like `controlById(.button, "xyz")` has the return type `?*Controls.Button`.

(Zig will unroll one of these functions per distinct `tag`, and so type-errors
may occur if something doesn't match up for one particular case! Conversely,
you can write code that wouldn't check for all variants if you don't plan on
using it for those, but it's a friendly act to yourself and others to write
explicit checks with explicit messages. :)

We fetch the `Control` as before, but now we use the [`@field`] builtin to
perform the equivalent of `c.blah`, where `blah` is specified by
[`@tagName(tag)`][`@tagName`].

The [`@tagName`] builtin returns a comptime string of the tag's name, so for
`.button` it gives `"button"`. This is what [`@field`] wants, and so the effect
is a safety-checked variant assertion, like we were doing in our "user" code
before, only now it's done as part of the getter itself.

If you wanted to, you could even make the function non-asserting, instead
returning `null` if the type was a mismatch:

```zig
fn controlById(
    comptime tag: std.meta.Tag(Control),
    id: []const u8,
) ?std.meta.TagPayload(Control, tag) {
    const c = self.controls.get(id) orelse return null;
    return switch (c) {
        tag |payload| => payload,
        else => null,
    };
}
```

You get the idea! You can do loads with this stuff.

</section>

[tagged union]: https://ziglang.org/documentation/master/#Tagged-union
[`inline else`]: https://ziglang.org/documentation/master/#Inline-Switch-Prongs
[`inline for`]: https://ziglang.org/documentation/master/#inline-for
[`inline while`]: https://ziglang.org/documentation/master/#inline-while
[`@tagName`]: https://ziglang.org/documentation/master/#tagName
[`@field`]: https://ziglang.org/documentation/master/#field
[`std.meta.Tag`]: https://ziglang.org/documentation/master/std/#std.meta.Tag
[`std.meta.TagPayload`]:  https://ziglang.org/documentation/master/std/#std.meta.TagPayload
