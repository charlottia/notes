---
title: "Soft skills: jujutsu early feelings"
created_at: 2024-11-07T18:07:00+1100
kind: article
description: >-
  Launching into jujutsu.
---

<section id="top">

I finally got bothered to try [jujutsu]. It's often hard to convey just how fast
I'm accustomed to moving with git, and so while there are many valid complaints
about its interface, object model design, etc., I'm really super fluent with it!

[jujutsu]: https://github.com/martinvonz/jj

So for a long time I was happy to let jujutsu just be a thing people were
talking about; simpler or better than git and so on, I didn't ever quite hear
anything that made learning it sound worthwhile yet.

Recently [Steve Klabnik's Jujutsu Tutorial passed by on Lobste.rs][steveklabnik]
again, and it was enough to get [Ashe] interested. After a few days of them having
a look, I bit the bullet and insisted we set up for both of us to use it[^dual].

[steveklabnik]: https://lobste.rs/s/mdfhda/steve_klabnik_s_tutorial_on_jujutsu_git
[Ashe]: https://kivikakk.ee

It's really good. We've been using it on every git repo we touch, to maximise
our exposure and really put it through its paces, and it's been so unexpectedly
rewarding.

Fluent git can involve a lot of rewriting history and working on and with the
commit DAG itself. jj elevates many of the involved operations to first-class
status, and jj's answer to git's index --- that the working tree represents the
state of the currently-edited commit, and editing the working tree edits the
commit --- is the core of the mind-frame shift, like kak/hx's pivot re: vi about
command sentence order.

Things that combine to change how things work include:

* The working tree reifies the edited commit, which obviates the index. This
  simplifies the design and allows for so many more fully-general operations.
  * Practically speaking, jj snapshots the working tree at the start of every
    command. (Now you know.)
  * As above, imo this is the core mind-frame shift required, and is what I see
    the most wailing and gnashing of teeth about. Do it.
* Rebases _always_ succeed, with conflicts stored meaningfully in history.
  Conflict resolution propagates automatically to descendent _changes_, which
  are not commits.
  * It's a little hard to describe exactly how neat this actually can be and is
    without your head already being in the jj model. If it sounds a bit magic,
    compared to the status quo, it honestly is.
* git's promise of at-least-never-losing-any-data is elevated to the level of
  the repository itself in the operation log.
  * Sometimes knee-deep in a complicated interactive rebase, I'll realise I've
    made a few too many wrong moves and it's easier just to abort and start
    over. The data's always safe, but on occasion you'll need to visit the
    reflog to retrieve it, and manoeuvring the repo back into a particular
    gnarly conflicted merge state can be frustrating. jj characterises every
    state-modifying operation in the "operation log", so you can instead play
    back and forth whatever you just did _to_ your repo, and not just what's
    _in_ it.
  * "Snapshot the working tree" is an example of an operation recorded in the
    oplog; it's not magic.
* If cheaper branching was a selling point for git[^svn], then branchless is the
  epitome of that selling point.
  * Every change can be a branch. Typical git usage relies on branches to know
    which commits in the database should be considered "reachable" and therefore
    not irrelevant and to be garbage collected. jj puts the heuristic in a
    different place: instead of guessing which commits are relevant, record when
    they *become* irrelevant. Moving off an empty commit? Abandon it. Edited
    a commit, or rebased some? Abandon the old version/s. When you make a few
    changes on a few new commits, they all simply stay put, and you can
    incorporate/ rebase/abandon them later as you see fit. That's how you
    accidentally an entire "stash" concept, and it's _easier_ to use than git
    stash.
  * Note the implication: you might accidentally some other (perhaps new!)
    concepts too, just from your regular jj use evolving some patterns.

Made this post because I noticed my log currently looks like this:

<pre><code><span class="s bold">@</span>  <span class="m bold">n</span><span class="cm bold">vxttvku</span> <span class="nn bold">charlotte@lottia.net</span> <span class="nt bold">2024-11-05 13:19:23</span> <span class="kp bold">8</span><span class="cm bold">dbb3ac9</span>
│  <span class="s bold">(empty) (no description set)</span>
○  <span class="m bold">o</span><span class="cm">ypwlzvr</span> <span class="nn">charlotte@lottia.net</span> <span class="nt">2024-11-05 13:18:23</span> <span class="s">git_head()</span> <span class="kp bold">9</span><span class="cm">d6049b2</span>
│  Imtui: object system, sigh
│ ○  <span class="m bold">rq</span><span class="cm">kpqpsk</span> <span class="nn">charlotte@lottia.net</span> <span class="nt">2024-11-05 13:19:07</span> <span class="kp bold">0</span><span class="cm">8d3afb3</span>
├─╯  play around with https://ziglang.org/devlog/2024/#2024-11-04
<span class="nt">◆</span>  <span class="m bold">y</span><span class="cm">mxnqszq</span> <span class="nn">charlotte@lottia.net</span> <span class="nt">2024-10-29 17:08:48</span> <span class="m">main</span> <span class="kp bold">fa</span><span class="cm">7f5da9</span>
│  Imtui: experiment with "generations" to GC/disregard killed components
<span class="cm">~  (elided revisions)</span>
│ ○  <span class="m bold">rs</span><span class="cm">xxxkzu</span> <span class="nn">charlotte@lottia.net</span> <span class="nt">2024-10-28 11:19:02</span> <span class="kp bold">2</span><span class="cm">819f0d1</span>
├─╯  Imtui: editors cont'd
<span class="nt">◆</span>  <span class="m bold">w</span><span class="cm">vwyouqo</span> <span class="nn">charlotte@lottia.net</span> <span class="nt">2024-10-28 11:13:26</span> <span class="kp bold">f4</span><span class="cm">a61c28</span>
│  Imtui: editors init
</code></pre>

Multiple branches, without names! It's happening.

</section>


[^dual]: tl;dr: [this][fish.nix], where `A` and `C` run `jj` with `JJ_USER` and
   `JJ_EMAIL` set accordingly.
[^svn]: At the time git started to really gain popularity, [Subversion] was popular,
   which itself became popular in part because it made branches so cheap. Subversion
   implemented branches as simply copies of a directory --- typically the root
   would have a `trunk` directory, equivalent to today's `main`, and to make a
   branch, you just recursively copy that to a subdirectory of the `branches` root
   directory. Subversion's key improvement is that the tree isn't actually
   copied in the repository; it can reuse the existing one, with deltas applied
   separately. Keep in mind the much smaller harddrives and lower connection
   speeds of the time.
   \
   This led to very busy trees, however, and commits to different branches would
   still interfere with each other and the mainline since they're in actual fact
   all sequential commits to one big tree, not to mention the much poorer tools for
   dealing with branches-as-embodied-in-the-tree. When the contents of a repo
   are numerous or large enough, this quickly becomes an end-user cost as well:
   the branches may be links on the server, but on your local filesystem they're
   full copies.
   \
   The costs are all doubled, too; Subversion's primary local knowledge of the
   repository (remember that it doesn't store history/isn't a "clone"!) is
   kept in the form of a copy of every currently checked-out file, used as the
   basis for a quick status/diff to know what you have changed. So 10MB of files
   stored in trunk and one branch will use 40MB of space on your disk.
   \
   Branching in Subversion requires online access to the repository, permissions
   to create the target, local diskspace to accommodate two copies of the
   source, and a repository-unique name.
   \
   git's by comparison needs none of the first three, and the last only
   locally.


[fish.nix]: https://github.com/kivikakk/vyxos/blob/fadc9f4d18e2cb33cb283cc459c39309e2adac36/home/fish.nix#L29-L54
[Subversion]: https://subversion.apache.org/
