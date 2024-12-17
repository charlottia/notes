---
title: "Comptime, flow, and exhaustiveness"
created_at: 2024-12-17T21:02:36+1100
kind: article
description: >-
  Make your own exhaustiveness rules up.
---

<section id="top">

Busy working on the [ADC][adc] lately, but I just happened upon this
kind-of-follow-up to the [non-intrusive vtable][vtable].

[adc]: https://github.com/charlottia/ava/tree/main/adc
[vtable]: https://lottia.net/notes/0011-non-intrusive-vtable.html

I have methods implemented by only some "subtypes", and usually "do nothing" is
the correct default, or perhaps "return `null`". They end up looking like this:

```zig
pub fn handleMouseDown(
    self: Control,
    b: SDL.MouseButton,
    clicks: u8,
    cm: bool,
) Allocator.Error!?Control {
    switch (self) {
        inline else => |c| if (@hasDecl(@TypeOf(c.*), "handleMouseDown")) {
            return c.handleMouseDown(b, clicks, cm);
        },
    }
    return null;
}

fn handleMouseDrag(self: Control, b: SDL.MouseButton) !void {
    switch (self) {
        inline else => |c| if (@hasDecl(@TypeOf(c.*), "handleMouseDrag")) {
            try c.handleMouseDrag(b);
        },
    }
}
```

'tis a fine barn, but sure 'tis no pool.

What I would keep encountering was that I'd write an implementation for a
“““““subtype”””””, and then run the program and wonder why the behaviour seemed
unchanged. It's amazing how many times you can encounter the exact same problem
--- in this case, a missing `pub` qualifier on the implementations, meaning
they're invisible to other files.

What if we made the default behaviour opt-in, instead of implicit? Here's an
example:

```zig
fn parent(self: Control) ?Control {
    switch (self) {
        inline else => |c| if (@hasDecl(@TypeOf(c.*), "parent")) {
            return c.parent();
        } else if (@hasField(@TypeOf(c.*), "orphan") and c.orphan) {
            return null;
        },
    }
}
```

We check if there's a `parent` decl, and call it if so. If not, we check for an
`orphan` field, and if it exists and is true, do our default action. Note that
we don't _assert_ this as the only other alternative. Let's see what happens if
we compile an existing control that doesn't supply either:

```
src/Imtui.zig:63:30: error: function with non-void return type '?Imtui.Control' implicitly returns
    fn parent(self: Control) ?Control {
                             ^~~~~~~~
src/Imtui.zig:71:5: note: control flow reaches end of body here
    }
    ^
referenced by:
    focus__anon_8053: src/Imtui.zig:352:35
    accelerate: src/controls/DialogButton.zig:67:29
```

The function implicitly returns! Both conditions evaluate to false at comptime,
so the body of the method ends up being totally empty. (Alternatively, if
you use `return switch`, you'll see a message about `error: expected type
'whatever', found 'void'`.)

It's not very helpful, because the reference trace refers to the point at
which this function gets *called*. We don't actually know which is the missing
implementation, just that it exists.

But that's okay, we can add that ourselves!

```zig
fn parent(self: Control) ?Control {
    switch (self) {
        inline else => |c| if (@hasDecl(@TypeOf(c.*), "parent")) {
            return c.parent();
        } else if (@hasField(@TypeOf(c.*), "orphan") and c.orphan) {
            return null;
        } else {
            @compileError(@typeName(@TypeOf(c.*)) ++ " doesn't implement parent or set orphan");
        },
    }
}
```

Ja nii:

```
src/Imtui.zig:70:17: error: controls.Dialog.Impl doesn't implement parent or set orphan
                @compileError(@typeName(@TypeOf(c.*)) ++ " doesn't implement parent or set orphan");
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
referenced by:
    focus__anon_8053: src/Imtui.zig:354:35
    accelerate: src/controls/DialogButton.zig:67:29
```

Finally, note how a field used this way must be: `comptime`!

```zig
comptime orphan: bool = true,
```

If not, its value won't be available at comptime, and codegen will need to
produce a runtime condition for the `c.orphan` check, meaning the possibility of
false is always entertained and the `@compileError` will fire.

Things to consider:

* It might be worth asserting in the first branch that `orphan` isn't set to
  true, to avoid any confusion about behaviour when both are set.
* We only got the exhaustiveness thing because this example returns a value.
  With `void` returns, the `@compileError` isn't optional if you want to know if
  you forgot.
* Did you buy the graphite tube?
* Try `comptime opaque: void` to avoid the need for `@hasDecl()` _and_ the
  boolean check! Does it work? Almost like little tags, attributes, hmmmmmm.

</section>
