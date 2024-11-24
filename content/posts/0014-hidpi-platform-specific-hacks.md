---
title: "Platform-specific hacks for high-DPI"
created_at: 2024-11-24T22:06:00+1100
kind: article
description: >-
  We need to avoid getting scaled by the compositor, to preserve our sharp edge.
---

<section id="top">

This was written up while working on [Ava BASIC][ava]'s IDE, the [Amateur
Development Client (ADC)][adc].

[ava]: https://github.com/charlottia/ava
[adc]: https://github.com/charlottia/ava/tree/main/adc

</section>


<section id="macos">

## macOS

* We set `.allow_high_dpi = true` when creating the window with SDL, which does
  the right thing on macOS.  We classify this situation as "native hidpi"; we
  recognise it by noting the created renderer has an output size 2x that of the
  window in both dimenisons.
    * We only need set the renderer scale factor to 2; everything else behaves
      as if it's at 1x automagically.
* `SDL_GetDisplayDPI` always returns the native DPI for the display.
  * On my Macbook's 14" Retina screen @ 3024 x 1964, this is around 255x255.
  * On a 32" 4K monitor, this is 137x137.
  * This appears reconstituted from other figures as it varies with
    floating-point tendencies between resolutions, but it's about right.

</section>


<section id="windows">

## Windows

* SDL's `.allow_high_dpi = true` doesn't do anything.
* We use the [`SetProcessDPIAware`] Win32 call so we don't get affected by
  Windows' automatic UI scaling.
* `SDL_GetDisplayDPI` seems to give `96 * ui_scaling_factor`, so we get 144x144
  with the default 150% UI scaling on piret, and not 125x125 like we actually
  have, but it's good enough.
* We then apply "manual hidpi" (see Linux).

[`SetProcessDPIAware`]: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setprocessdpiaware

</section>


<section id="linux">

## Linux

* SDL's `.allow_high_dpi = true` doesn't do anything.
* `SDL_GetDisplayDPI` always returns the native resolution DPI for the display,
  on both X and Wayland.

Note: Trying to get the acutal DPI/scaling factor in use seems Really Hard™.
I actually didn't even bother trying at all at first, and jumped straight to
the current solution, but after I ironed out all three I thought, "wouldn't
it be nice?" Anyway: hahahahahahahahaha. I'm sure there's a nice way to do it.
(hahahahahahaha.)

At some point I started feeling really committed to writing this note, so let's
actually research this properly. The first obvious bifurcation is X vs Wayland.
Going any lower than that is a path to madness (i.e. code specific to e.g. KDE,
your particular Wayland compositor, etc.) and frankly my life is full of those
as it is.


### X

Let's try to get an answer for X first. I normally use Wayland --- on booting
my machine into X instead (still Plasma 6), I'm greeted with my UI entirely
unscaled! I'm surprised. Let's investigate ways to obtain a figure here:

* `xrdb -query` doesn't have an `Xft.dpi` entry.
* `xrandr` gives 2560x1600, and the monitor's size as 345mm x 215mm (which is
  correct, and gives us a PPI of 188x189).  It doesn't hazard an attempt at
  giving any UI scaling factor or DPI setting (despite accepting one with
  `xrandr --dpi`? what must that actually do?).
* `xdpyinfo` (`nixpkgs#xorg.xdpyinfo`) gives 2560x1600 at 96 dpi, and notes the
  screen dimensions as 677mm x 423mm, which appears to be calculated simply from
  the previous figures.
* Some folks have suggested grepping X's logs! Where found, it said 96. (Can you
  imagine if this just had The Answer? "Please specify path to your X server's
  logfile or supply systemd unit name to continue.")
  
I reset the UI scaling factor (to 150%), and then restarted X (without which
about half the items had it applied, half not).

Only `xrdb -query`'s output changed: `Xft.dpi: 144` has appeared.  This looks
useful --- it looks like the `96 * ui_scaling_factor` thing as well here.
Let's sigh and verify by checking 125% (it writes, having already gone back
into Wayland ... ugh. The worst part is the keyboard (I typo my password on it
far too often; not used to the Framework), and [a bug] somewhere between KDE,
SDDM and the laptop's fingerprint reader means logins take about 30 seconds
to process, and honestly I'm just one cat up against the world here).  Yes!
`Xft.dpi: 120`!

[a bug]: https://github.com/NixOS/nixpkgs/issues/239770#issuecomment-1868508908

Overall, there's not a lot; it is clear that most desktop environment toolkits
implement this themselves, and so there's not necessarily a straight answer.
Querying the font DPI X resource seems likely to give a useful number, though,
when present, and I think we can call that Good Enough™. We have to shell out,
which is ugly as hell, or query the X server ourselves.


### Wayland

First up, let's try all the X methods against Xwayland, just in case we get an
easy win. This is at 150%.

* `xrdb -query` gives `Xft.dpi: 144`.
* `xrandr` gives the same as real X. (Not the actual same; a lot is different
  thanks to the virtual server. But the relevant stuff is identical.)
* `xdpyinfo` does likewise.
* There's a lot less in the logs/journals for Wayland that I've found.

What about 125%? `xrdb -query` gives `Xft.dpi: 120`, rest the same. 100%?
`Xft.dpi: 96`, the first time we see this result explicitly here.

And it turns out, that's it: that's the solution. We can get some minimally
useful information for both display managers with the one method.

... but if we did want more information from Wayland, does its design mean
we can get it? Turns out, yes.

`wayland-info` (`nixpkgs#wayland-utils`) gives us:

* scaling factor of `2` in `wl_output` interface properties; and
* logical display size of 1707x1067 from `zxdg_output_manager_v1` interface, but
  maybe that's not (as) reliable.

The `2` there is an interesting one. It's `1` at 100%, but `2`
above that. Above 200% or so it seems to go to `3`. This is
[`wayland_server::protocol::wl_output::WlOutput::scale`][scale]; I guess it (?
Plasma?) gets us 150% by rendering at 200%, and then bitmap-scaling the result?
That doesn't sound right. [Oh boy].

[scale]: https://docs.rs/wayland-server/latest/wayland_server/protocol/wl_output/struct.WlOutput.html#method.scale
[Oh boy]: https://dudemanguy.github.io/blog/posts/2022-06-10-wayland-xorg/wayland-xorg.html

The `zxdg_output_manager_v1` figure gives us exactly what we want, in
[`zxdg_output_v1::logical_size`][size], but it looks comparatively new/
unstable and isn't a core part of the protocol, so I assume it's comparatively
unreliable. (Using that we can calculate the actual set DPI, i.e. 125x125.)

[size]: https://wayland.app/protocols/xdg-output-unstable-v1#zxdg_output_v1:event:logical_size

I guess on Wayland (with Xwayland) the perfect priority would be
`zxdg_output_v1::logical_size` > `xrdb -query` > `wl_output::scale`. But I'm going
to assume Xwayland is in fact ubiquitous, and therefore `xrdb -query` will have
to do for both.

(If I actually end up implementing this, I'm probably going to eventually
succumb and implement the X calls to avoid the subprocess.)


### Okay, but what is the actual solution?!

When the reported DPI is greater than or equal to 100 in either dimension,
set the renderer scale to 2, double both the window dimensions, and set the
effective scale to 2.  The effective scale is divided from cursor positions in
mouse events before they're handled.

</section>


<section id="wtf">

## wtf

We check this immediately after doing the macOS-style hidpi check, which skips
the rest of this if taken, i.e. if the window is on a Retina screen.

Because of that, and because we call `SetProcessDPIAware` on Windows at startup,
"reported DPI" has the following meanings (with examples from above scenarios
given):

* macOS: native, unscaled DPI. (255x255 on Retina, 137x137 on 4K)
* Windows: `96 * ui_scaling_factor`. (144x144)
* Linux: native, unscaled DPI. (188x189)

So in any case, we see our DPI >= 100 and just run everything at 2x.  If the
Windows user happened to be running at 100%, then we would too, and would fit
right in.  If we REALLY cared about that happening on Linux too, we could go the
`xrdb -query` path. That way lies misery, I know it.

</section>
