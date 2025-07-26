---
title: "Fortune habits in Nix"
created_at: 2025-07-26T15:10:00+1000
kind: article
description: >-
  Let's implement "Using fortune to reinforce habits" in Nix.
---

<section id="top">

I recently saw and liked [Judy2k's "Using fortune to reinforce
habits"](https://www.judy.co.uk/blog/using-fortune-to-reinforce-habits/)
--- building effective habits is an under-appreciated part of learning any
discipline.  (And `xh` is one I had the [exact same trouble with][xh].)  Let's
implement it in our Nix setup.

[xh]: https://nossa.ee/~talya/vyx/blob/main/c008ed3595836a4984aa9075ef4b478094bb527f/home.nix#L54


## Step 0: don't install `fortune`

You don't have to do this.  That's probably one of the neatest parts of Nix
right there --- you can have `fortune` embedded in your daily workflow _without_
having to expose it globally, without accidentally tab-completing `strfile` or
`rot` when working and having no idea why that's a thing.


## Step 1: write your habits file

This file goes into your Nix configuration, whether it's a nix-darwin flake or a
vanilla NixOS install with all your config in `/etc/nixos`.

Write your lines, with `%` separating entries.  Don't run `strfile` on it ---
remember, we didn't put `fortune` in our PATH, and we don't need to do that
work, nor do we want to add a manual step (running `strfile`) for us to forget
later.

I'm assuming it's called `habits` hereon.  Here's what [my first version] of
`habits` looks like:

```
mtr for traceroute.
%
entr to re-run on file change.
%
xh is our HTTPie replacement!
%
fd [pattern] [path ...]
%
Try using gg for jj.
```

Start small.  Once you're seeing these regularly, you'll also remember where to
add new ones when they occur to you!

[my first version]: https://nossa.ee/~talya/vyx/blob/main/9fa6d6ee497749bc119860292ed58704e6b4ec45/home/habits


## Step 2: write a derivation that compiles your habits file

We want to run `fortune`'s `strfile` on the habits file.  We need to store the
result side-by-side with the input; the output of `strfile` is just an index
into the original.

```nix
let
  inherit (pkgs) fortune;
in
pkgs.stdenv.mkDerivation {
  name = "vyx-habits";
  src = ./habits;

  unpackPhase = ''
    true
  '';

  buildInputs = [ fortune ];

  buildPhase = ''
    strfile $src habits.dat
  '';

  installPhase = ''
    mkdir -p $out
    cp $src $out/habits
    cp habits.dat $out/habits.dat
  '';

  passthru = {
    inherit fortune;
  };
};
```

I put this in config evaluated by Home Manager, but you can put it anywhere you
have access to Nixpkgs.  Let's go through it step-by-step.

First, we bring `fortune` in scope.  The [package in Nixpkgs] has `fortune` and
`strfile` in its `bin` output.

Now we create a derivation.  We include the habits file we wrote as the `src`
attribute, and replace the `unpackPhase` with a no-op since there's nothing
to extract.

`fortune` is the lone build input, meaning that its `bin` outputs (including
`strfile`) will be in `$PATH`.  To build, we run `strfile` on the source. The
source will be in the Nix store, so we supply an output filename --- by default,
`strfile` will try to write its output next to the input.

To install, we create the output directory (this is a Nix-ism you'll see
everywhere), and then copy both the input file and the compiled index there.

Finally, we pass through the `fortune` package we used as an attribute on this
derivation itself.  We'll use this to actually call `fortune` later.

Lovely!  We now have a derivation that indexes our habits file, and puts the
result somewhere that we can pass to `fortune` and have it Just Work(tm).

[package in Nixpkgs]: https://search.nixos.org/packages?channel=25.05&show=fortune&from=0&size=50&sort=relevance&type=packages&query=fortune-mod


## Step 3: integrate with your shell

This will vary depending on your shell setup.  I'll show how it works with mine.

I configure fish using Home Manager.  One of the configuration
options is [`programs.fish.interactiveShellInit`], which is shell
code called when an interactive shell is initialising.  I set the
`fish_greeting` variable here, which the default [`fish_greeting`
function](https://fishshell.com/docs/current/cmds/fish_greeting.html) just
displays.

I bind the above derivation to the name `habits`, and then set `fish_greeting`
by invoking the passed-through `fortune` package, with the argument being the
base name of the complied `habits`.  (`fortune` will look for the `.dat` file
next to it.)

```nix
let habits =
  let
    inherit (pkgs) fortune;
  in
  pkgs.stdenv.mkDerivation {
    # ... (unchanged from above) ...
  };
in
{
  programs.fish = {
    interactiveShellInit = ''
      # ... (elided) ...
      set fish_greeting 'Nyonk! '(${habits.fortune}/bin/fortune ${habits}/habits)
    '';
  };
}
```

Note how our use of the `passthru` attribute means we don't actually have the
`fortune` package in scope anywhere except building the derivation itself; this
is a nice kind of clean, and means there's no chance of e.g. using a different
`fortune` to compile the index than what we use to read it.  (There's probably
very little chance of a breaking change here between `fortune` versions, lol,
but imagine (much) bigger systems and you can see how this could be handy. :))

[`programs.fish.interactiveShellInit`]: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.interactiveShellInit
[`fish_greeting` function]: https://fishshell.com/docs/current/cmds/fish_greeting.html
[src]: https://nossa.ee/~talya/vyx/blob/main/9fa6d6ee497749bc119860292ed58704e6b4ec45/home/fish.nix#L47


## Step 4: prophet

Yay, we're done!

Now, whenever you modify the content of `habits` in your configuration, a new
derivation will be built, and your shell init will use it.

Let's have a look at what our built fish config looks like:

```console
$ grep Nyonk ~/.config/fish/config.fish
set fish_greeting 'Nyonk! '(/nix/store/543q6d77f4p27572xb9c5wngg7mg5rh8-fortune-mod-3.24.0/bin/fortune /nix/store/ggp28h3cmvciyaxfr0rxaz154ljap89l-vyx-habits/habits)
```

oh yeah i love horizontal scrolling.  And what does our derivation's output
directory look like?

```console
$ ls -l /nix/store/ggp28h3cmvciyaxfr0rxaz154ljap89l-vyx-habits
total 8
-r--r--r-- 1 root wheel 134 Jan  1  1970 habits
-r--r--r-- 1 root wheel  48 Jan  1  1970 habits.dat
```

Neat!


## Step 5: next steps

You could try some of these:

* Instead of just packaging the habits, [write out a script] that actually calls
  `fortune` with the supplied data.  Then using it is just a matter of invoking
  your package's `bin` output.
* Alternatively, put together the calling syntax in a `passthru` attribute, and
  just interpolate that into your shell init.  Shell-specific, but kinda neat.
* Want some experience writing NixOS modules?  You could write a module which
  builds this and injects it into your shell config with a single `enable =
  true;`.  Bonus points for accepting the habits data as a configuration option!

[write out a script]: https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeShellScriptBin

</section>
