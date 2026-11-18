# Myke's Dotfiles

A place to store my system configuration, shared scripts, etc. Stealing (and feedback!) encouraged :-)

Recently overhauled as I set up a new development environment.

## Setup

To bootstrap a system with these dotfiles run:

```sh
  git clone git@github.com:mykecameron/dotfiles.git
  cd dotfiles
  bin/bootstrap
```

`bin/bootstrap` is safe to re-run: it sources `bashrc` from `~/.bashrc`, symlinks
`ghostty/config`, the hooks in `claude/hooks`, `claude/skills`, `bin/pr-status`, and
`tool-versions` into place (moving anything already there to `.bak`), and merges
each `claude/settings.*.json` fragment into `~/.claude/settings.json`. Merging only
adds keys, so deleting a fragment later does not remove what it already merged.

`tool-versions` becomes `~/.tool-versions`, asdf's global fallback. Without it
asdf won't resolve `ruby` outside a project that pins a version, so any Ruby
script on PATH dies with "No version is set for command ruby" the moment you run
it from somewhere like `~`. Bump it when you retire a version.

## pr-status

`bin/pr-status` lists your open pull requests grouped by what each one needs, in
the order you'd act on them:

1. **Ready to merge** — approved, checks green, mergeable
2. **Needs action** — failing checks, changes requested, unresolved review
   comments, merge conflicts, or behind the base branch
3. **In good shape, needs review** — nothing blocking, waiting on reviewers (or
   flagged when no reviewers were requested)
4. **Draft**

Oldest first inside each group, so whatever has been waiting longest is on top. A
draft with something broken lands in **Needs action** tagged `draft ·` rather
than hiding in the draft group.

```sh
  pr-status                        # you, in the repo you're standing in
  pr-status --author someone-else
  pr-status --all-repos
  pr-status --limit 100
```

Ruby with no gems, and one `gh api graphql` call rather than one per PR. Needs
[`gh`](https://cli.github.com) authenticated. `bootstrap` links it into
`~/.local/bin`, which is already on PATH.

In a terminal it colours the group headings and makes each PR number a clickable
hyperlink. Piped, or with `NO_COLOR` set, it drops the escapes and adds a plain
URL column, so `pr-status | pbcopy` gives you something pasteable.

## Claude Code skills

`claude/skills` becomes `~/.claude/skills`, so each skill there is a slash command
in every project. `/triage-review <path>` triages a code-review markdown file: it
checks each finding against the code, says which to fix and why the rest are
skipped, and drafts PR description notes for the skips.

## Claude Code notifications

A silent macOS banner when Claude wants approval or finishes a task, so a session
in a background tab doesn't sit there unnoticed.

- `claude/hooks/notify.sh` — the banner itself, run by Claude's `Notification` and
  `Stop` hooks. Titled with whatever the Ghostty tab shows, so several sessions in
  one directory stay distinguishable. Completion banners are skipped when Ghostty
  is already frontmost. Clicking a banner focuses the Ghostty tab or split the
  session is running in.
- `bin/build-claude-notifier` — builds `~/Applications/Claude Code Notifier.app`,
  a copy of [terminal-notifier](https://github.com/julienXX/terminal-notifier)
  wearing the robot in `claude/notifier/icon.svg`. macOS takes a banner's icon
  from the app that sends it, so a custom icon means a custom app. `bootstrap`
  runs it when the app is missing. Rerun it after editing the icon. Needs Chrome
  to render the SVG.
- `claude/settings.notifications.json` — merged rather than symlinked, because
  Claude rewrites `settings.json` with a temp file and a rename, which would
  quietly replace a symlink with a regular file.
- `ghostty/config` — turns Claude's terminal bell into a dock bounce, a 🔔 in the
  tab title, and a border on the split that's waiting. All silent.

Both apps need permission in System Settings → Notifications, set to **Alerts**
rather than Banners so a missed prompt stays on screen: **Ghostty** and **Claude
Code**. The first click also asks to let Claude Code control Ghostty, which is
how it picks the right tab.

## Caveman subagents

Subagents write their final report in a terse "caveman" voice, so less of the
parent session's context goes to reading them. The main chat, and the briefs it
sends to subagents, stay plain English.

- `claude/hooks/caveman-subagent.sh` runs on Claude's `SubagentStart` hook and adds
  `claude/caveman/rules.md` to every subagent's context.
- `claude/settings.caveman.json` registers the hook. Delete it before running
  `bootstrap` to opt out.

The rules are adapted from the `caveman` skill in
[JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) at `a192894`,
under the Apache 2.0 license in `claude/caveman/LICENSE`. Changes: the reader is
the parent agent instead of a person. The parts about switching modes, tool-run
status lines, reply language and talking to a user are removed. A new rule lets
the brief override the voice when it asks for a specific format.
