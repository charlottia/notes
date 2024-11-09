---
title: "Git and jujutsu: in miniature"
created_at: 2024-11-09T14:30:00+1100
kind: article
description: >-
  A concrete example of Git and jujutsu usage compared.
---

<section id="top">

Last night in bed, I realised we'd encountered a scenario at work during the day
where something happened so fluidly in jujutsu that it'd make a good case story!
Let's compare, step by step, how it'd look with git.

The stage is set: you're working on a [big, old, legacy codebase][radiopaedia],
and you're 10 commits deep in a branch where you're adding a new parsing
component which will, by the time the branch is merge-ready, completely supplant
an old one and all its uses.

[radiopaedia]: https://radiopaedia.org

The parser is mostly called through a centralised place, which is well-covered
by tests, so you can feel _reasonably_ assured that green CI will mean you're
on the right track, and you've been removing parts of the old parser as you
introduce the new.

But what's this? There's an outlying case where a method on some random model
calls into the component directly --- unlike most uses, it's just calling the
parser to clean up some input. And while the method is covered by a number of
tests, this particular function of it isn't at all --- you could replace the
parser with the identity function and these tests would be fine with that.

So we need a new test. We're currently in some other WIP on this branch, and the
original parser is half-taken to bits, so we'll write the tests against trunk,
called `develop` here.

```console?prompt=$
$ jj new develop -m 'content_spec: assert body_excerpt strips tokens.'
Working copy now at: rltuvkoz 9b9f6db4 (empty) content_spec: assert body_excerpt strips tokens.
Parent commit      : xkowykqr 83ad162d develop | (empty) Merge pull request #1736 from backfill-pr
Added 10 files, modified 46 files, removed 4 files
```

```console?prompt=$
$ git checkout develop
error: Your local changes to the following files would be overwritten by checkout:
        app/lib/rml_parser.rb
        spec/lib/rml_parser_spec.rb
Please commit your changes or stash them before you switch branches.
Aborting
$ git stash
Saved working directory and index state WIP on (no branch): 478c7377 remove local artefacts.
$ git checkout develop
Previous HEAD position was 478c7377 remove local artefacts.
Switched to branch 'develop'
Your branch is up to date with 'origin/develop'.
```

Now, a seasoned git developer (with a good vcs prompt for their shell) will know
to stash reflexively, and indeed the above three commands under my aliases would
be `co develop`, `st`, `co develop`, but it's interesting that we kind of have
to context-switch for a moment here and think, "OK, working copy changes, maybe
some tracked, some untracked, put them all into this 'stash' thing over there so
we can move around freely".

So we write our test, confirm it's actually asserting the behaviour. We're now here:

```console?prompt=$
$ jj status
Working copy changes:
M spec/models/content_spec.rb
Working copy : rltuvkoz e0186732 content_spec: assert body_excerpt strips tokens.
Parent commit: xkowykqr 83ad162d develop | (empty) Merge pull request #1736 from backfill-pr
```

```console?prompt=$
$ git status -sb
## develop...origin/develop
 M spec/models/content_spec.rb
```

</section>

<section id="manoeuvre-jj">

## The manoeuvre: jj

Great! We want to introduce this change into our branch, so we can be sure we
don't break this use case. We don't really want it right at the tip, since there's a
progression of commits; we want it a few commits before.

```jjlog
@  rl!tuvkoz ashe@kivikakk.ee 2024-11-09 11:55:13 e0!186732
│  content_spec: assert body_excerpt strips tokens.
◆    xk!owykqr redacted@redacted.com 2024-11-08 15:30:54 develop git_head() 8!3ad162d
├─╮  (empty) Merge pull request #1736 from backfill-pr
│ │
│ ~
│
~  (elided revisions)
│ ○  xn!srwqok ashe@kivikakk.ee 2024-11-09 11:54:38 ec!3df6f8
│ │  (no description set)
│ ○  rv!umupsn ashe@kivikakk.ee 2024-11-09 11:54:38 rml-parser* 478!c7377
│ │  remove local artefacts.
│ ○  pp!mltptr ashe@kivikakk.ee 2024-11-09 11:54:38 25b!122ab
│ │  Token: migrate uses of #token to #original_token.
│ ○  pyt!wvkmx ashe@kivikakk.ee 2024-11-09 11:54:38 273!16b9a
│ │  RmlParser: implementing in Token.
│ ○  nl!rsutxv ashe@kivikakk.ee 2024-11-09 11:54:38 3e7!613e7
│ │  RmlParser: strip_tokens.
│ ○  pyp!uqnwp ashe@kivikakk.ee 2024-11-08 16:08:40 1be!aebab
│ │  RmlParser: blocks everywhere, include offset in bc.
│ ○  uv!mwxovu ashe@kivikakk.ee 2024-11-08 15:29:14 b0c!4bbba
│ │  RmlParser: test roundtrip.
```

Change `nlrsutxv` (commit `3e7613e7`) introduces the change we'd like the test
to inform, so we want to slot the test in right before then.

```console?prompt=$
$ jj rebase -r @ -B nl
Rebased 1 commits onto destination
Rebased 5 descendant commits
Working copy now at: rltuvkoz 99a0a2a0 content_spec: assert body_excerpt strips tokens.
Parent commit      : pypuqnwp 1beaebab RmlParser: blocks everywhere, include offset in bc.
Added 7 files, modified 39 files, removed 8 files
```

[`jj rebase`] can rebase a "branch" (`-b`), a revision and its descendants
(`-s`), or just a single revision (`-r`). `-r @` means the revision currently
edited in the working copy. `-B` means "insert before".

[`jj rebase`]: https://martinvonz.github.io/jj/latest/cli-reference/#jj-rebase

The log now looks like this:

```jjlog
○  xn!srwqok ashe@kivikakk.ee 2024-11-09 12:02:07 cef!52288
│  (no description set)
○  rv!umupsn ashe@kivikakk.ee 2024-11-09 12:02:07 rml-parser* 735!abf79
│  remove local artefacts.
○  pp!mltptr ashe@kivikakk.ee 2024-11-09 12:02:07 f34!335bf
│  Token: migrate uses of #token to #original_token.
○  pyt!wvkmx ashe@kivikakk.ee 2024-11-09 12:02:07 0ff9!0a43
│  RmlParser: implementing in Token.
○  nl!rsutxv ashe@kivikakk.ee 2024-11-09 12:02:07 783!90b57
│  RmlParser: strip_tokens.
@  rl!tuvkoz ashe@kivikakk.ee 2024-11-09 12:02:07 99a!0a2a0
│  content_spec: assert body_excerpt strips tokens.
○  pyp!uqnwp ashe@kivikakk.ee 2024-11-08 16:08:40 git_head() 1be!aebab
│  RmlParser: blocks everywhere, include offset in bc.
○  uv!mwxovu ashe@kivikakk.ee 2024-11-08 15:29:14 b0c!4bbba
│  RmlParser: test roundtrip.
```

We can now return to what we were doing, WIP ready for us to resume as we ever
were:

```console?prompt=$
$ jj edit xn
Working copy now at: xnsrwqok cef52288 (no description set)
Parent commit      : rvumupsn 735abf79 rml-parser* | remove local artefacts.
Added 1 files, modified 9 files, removed 6 files
```

Note that git commit IDs have changed, as you'd expect, but the jj change
IDs haven't. This stability of identity is very handy --- `xn` was what I was
working on before I started this aside, and it still is afterwards.

The other side of this is the `rml-parser` bookmark --- jj's equivalent to git's
branches, but used far less frequently (most often for git interop) --- has
_followed_ its change, with the asterisk after noting it's diverged from the
remote one. You don't have to chase down your branches after a rebase.

</section>

<section id="manoeuvre-git">

## The manoeuvre: git

How does the same play out with git? Let's look at the commit log from git's
point of view:

```
* 478c7377a4 (Fri, 8 Nov 2024) - (rml-parser) remove local artefacts. <Asherah Connor>
* 25b122abd8 (Fri, 8 Nov 2024) - Token: migrate uses of #token to #original_token. <Asherah Connor>
* 27316b9a2e (Fri, 8 Nov 2024) - RmlParser: implementing in Token. <Asherah Connor>
* 3e7613e704 (Fri, 8 Nov 2024) - RmlParser: strip_tokens. <Asherah Connor>
* 1beaebab8c (Fri, 8 Nov 2024) - RmlParser: blocks everywhere, include offset in bc. <Asherah Connor>
* b0c4bbbafb (Fri, 8 Nov 2024) - RmlParser: test roundtrip. <Asherah Connor>
```

We want to introduce our change --- currently just an untracked change in the
working tree, with `develop` checked out --- before commit `3e7613e704`.

We have two ways of getting it there:

1. Stash the change, interactively rebase `rml-parser` and stop after the
   previous commit (`edit 1beaebab8c`), pop stash, commit, continue rebase.

2. Commit the change now, interactively rebase `rml-parser` and add a `pick`
   line for our new commit in the right place.

I tend to commit early and often, so I'm more a fan of #2 as a rule, and
we're also already managing one item on the stash (our WIP from the tip of the
branch), and while there's no problem with putting as much as we want on it
(it's a very competent stack!), I just don't wanna.

Alas, more choices:

1. Commit to `develop`, copy the commit ID to the pasteboard, hard reset
   `develop` back to its previous value.
2. Create a new branch, commit to that, delete branch when done.
3. Detach HEAD, calm your git's nerves, it's ok I promise[^advice], commit.

We don't really want _this_ commit on a branch, but git really wants us to want
a branch. Let's go with purity.

```console?prompt=$
$ git checkout --detach
M       spec/models/content_spec.rb
HEAD is now at 83ad162d7c Merge pull request #1736 from backfill-pr
$ git add -p
[...]
$ git commit -m 'content_spec: assert body_excerpt strips tokens.'
[detached HEAD 6005753744] content_spec: assert body_excerpt strips tokens.
 1 file changed, 8 insertions(+)
```

Now it's time for the manoeuvre.

```console?prompt=$
$ git checkout rml-parser
Warning: you are leaving 1 commit behind, not connected to
any of your branches:

  6005753744 content_spec: assert body_excerpt strips tokens.

Switched to branch 'rml-parser'
$ git rebase -i 3e7613^
```

We're presented with this:

```
pick 3e7613e704 RmlParser: strip_tokens.
pick 27316b9a2e RmlParser: implementing in Token.
pick 25b122abd8 Token: migrate uses of #token to #original_token.
pick 478c7377a4 remove local artefacts.
```

Very easy: we add `pick 6005753744` above the first line, save and quit.

```console?prompt=$
Successfully rebased and updated refs/heads/rml-parser.
```

Here's our git log:

```
* 7b836073ca (Fri, 8 Nov 2024) - (HEAD -> rml-parser) remove local artefacts. <Asherah Connor>
* 70626ff5cb (Fri, 8 Nov 2024) - Token: migrate uses of #token to #original_token. <Asherah Connor>
* b4089df702 (Fri, 8 Nov 2024) - RmlParser: implementing in Token. <Asherah Connor>
* e385f17253 (Fri, 8 Nov 2024) - RmlParser: strip_tokens. <Asherah Connor>
* 652607c2f0 (Sat, 9 Nov 2024) - content_spec: assert body_excerpt strips tokens. <Asherah Connor>
* 1beaebab8c (Fri, 8 Nov 2024) - RmlParser: blocks everywhere, include offset in bc. <Asherah Connor>
* b0c4bbbafb (Fri, 8 Nov 2024) - RmlParser: test roundtrip. <Asherah Connor>
```

Don't forget to pop the stash!

```console?prompt=$
$ git stash pop
On branch rml-parser
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   app/lib/rml_parser_flux.rb

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   app/lib/rml_parser.rb
        modified:   spec/lib/rml_parser_spec.rb

Dropped refs/stash@{0} (d5c281196fa218a33a55538111fa7770284ca2cb)
```

Damn. I forgot to supply `--index`, and only new files (which were tracked
at the time of `stash`) are added to the index; all other stashed changes are
restored into the working copy, but not into the index. Oh well, it's git: I can
just go again with the stash reference from the last line.

</section>

<section id="remarks">

## Remarks

The bit that got me was that git really forces me to make a lot of decisions I
don't actually care about. How will I save my WIP while I'm off on this quest?
Do I want to juggle stashes and my working tree, or throw commits around? How
will I get a commit where I want it? Do I need to come up with a branch name?
And how much of all this needs to just sit in my head or pasteboard, lest I
forget what I was in the middle of?

It's astonishing, too, that one of the most powerful tools git has to rewrite
history is "provide a script which sequentially constructs the DAG you want,
where you can insert breakpoints to manually do things you can't express in the
script". With jj you just .. put the commit there. It was already in a commit
because everything is. And when you go back to where you were, everything is
still there, because it was a commit, too, just an unfinished one.

</section>

[^advice]: `git config --global advice.detachedHead false`
