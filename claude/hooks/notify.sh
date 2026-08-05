#!/bin/sh
# Desktop notifications for Claude Code events. Invoked as `notify.sh needs-input`
# or `notify.sh done` with the hook payload on stdin.
#
# Escape sequences are not an option here: hooks are spawned without a
# controlling terminal, so /dev/tty is unopenable and OSC 777 can't be written.
set -eu

kind="${1:-done}"
payload=$(cat)

session_id=$(printf '%s' "$payload" | /usr/bin/jq -r '.session_id // empty')
transcript=$(printf '%s' "$payload" | /usr/bin/jq -r '.transcript_path // empty')
cwd=$(printf '%s' "$payload" | /usr/bin/jq -r '.cwd // empty')

# Label the banner with whatever the Ghostty tab is showing, so several sessions
# in one directory stay distinguishable. Sources, in the order the tab uses them:
# an explicit /rename, else the rolling AI-generated title, else the directory.
title=""

if [ -n "$session_id" ]; then
  for f in $(ls -t "${CLAUDE_CONFIG_DIR:-$HOME/.claude}"/sessions/*.json 2>/dev/null); do
    name=$(/usr/bin/jq -r --arg sid "$session_id" \
      'select(.sessionId == $sid and .nameSource == "user") | .name // empty' \
      "$f" 2>/dev/null || true)
    if [ -n "$name" ]; then
      title="$name"
      break
    fi
  done
fi

if [ -z "$title" ] && [ -f "$transcript" ]; then
  title=$(/usr/bin/tail -r "$transcript" 2>/dev/null \
    | /usr/bin/jq -rR 'fromjson? | select(.type == "ai-title") | .aiTitle // empty' 2>/dev/null \
    | /usr/bin/head -1 || true)
fi

if [ -z "$title" ] && [ -n "$cwd" ]; then
  title=$(basename "$cwd")
fi
[ -n "$title" ] || title="Claude Code"

case "$kind" in
  needs-input)
    body=$(printf '%s' "$payload" | /usr/bin/jq -r '.message // "Waiting for you"')
    ;;
  *)
    # A finished response is only worth interrupting for if Ghostty isn't already
    # in front — otherwise every short conversational turn would pop a banner.
    front=$(lsappinfo info -only bundleid "$(lsappinfo front)" 2>/dev/null || true)
    case "$front" in
      *com.mitchellh.ghostty*) exit 0 ;;
    esac
    body="Finished — ready for your next prompt"
    ;;
esac

/usr/bin/osascript - "$title" "$body" <<'APPLESCRIPT' >/dev/null 2>&1 || true
on run argv
  display notification (item 2 of argv) with title (item 1 of argv)
end run
APPLESCRIPT
