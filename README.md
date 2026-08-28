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
`ghostty/config`, `claude/hooks/notify.sh`, `bin/pr-status`, and `tool-versions`
into place (moving anything already there to `.bak`), and merges
`claude/settings.notifications.json` into `~/.claude/settings.json`.

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

## Claude Code notifications

A silent macOS banner when Claude wants approval or finishes a task, so a session
in a background tab doesn't sit there unnoticed.

- `claude/hooks/notify.sh` — the banner itself, run by Claude's `Notification` and
  `Stop` hooks. Titled with whatever the Ghostty tab shows, so several sessions in
  one directory stay distinguishable. Completion banners are skipped when Ghostty
  is already frontmost.
- `claude/settings.notifications.json` — merged rather than symlinked, because
  Claude rewrites `settings.json` with a temp file and a rename, which would
  quietly replace a symlink with a regular file.
- `ghostty/config` — turns Claude's terminal bell into a dock bounce, a 🔔 in the
  tab title, and a border on the split that's waiting. All silent.

Both apps need permission in System Settings → Notifications, set to **Alerts**
rather than Banners so a missed prompt stays on screen: **Ghostty**, and **Script
Editor** (which is what `osascript` notifications are attributed to).