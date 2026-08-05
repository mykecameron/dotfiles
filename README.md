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
`ghostty/config` and `claude/hooks/notify.sh` into place (moving anything already
there to `.bak`), and merges `claude/settings.notifications.json` into
`~/.claude/settings.json`.

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