#!/bin/bash
# sessions panel backend for index.jsx (v1.1)
#   list            json for the panel
#   focus <name>    focus the kitty window showing <name>, else attach in a new one
#   attach <name>   new kitty window attached to <name> (resurrects exited)
#   delete <name>   delete an exited session
# absolute paths everywhere: übersicht runs commands with a minimal PATH.
set -uo pipefail
Z=/opt/homebrew/bin/zellij
JQ=/opt/homebrew/bin/jq
KITTY=/opt/homebrew/bin/kitty
AERO=/opt/homebrew/bin/aerospace
CS="$HOME/.claude/sessions"

valid() { [[ "${1:-}" =~ ^[A-Za-z0-9._-]+$ ]] || { echo "bad session name" >&2; exit 2; }; }
orempty() { [ -n "$1" ] && echo "$1" || echo '[]'; }

# [{name, age, exited}] in zellij order (oldest first)
zsessions() {
  "$Z" list-sessions -n 2>/dev/null | "$JQ" -Rn '
    [inputs | select(test("\\[Created")) |
      { name: (split(" ")[0]),
        age: (((capture("Created (?<a>[0-9]+[a-z]+)") | .a) // "")
              | sub("years?";"y") | sub("months?";"mo") | sub("days?";"d")),
        exited: test("EXITED") }]'
}

# ["name", ...] sessions with a client process: `zellij a|attach [flags] <name>`
attached() {
  ps -axo command= | awk '$1 ~ /(^|\/)zellij$/ && ($2 == "a" || $2 == "attach") { print $NF }' \
    | sort -u | "$JQ" -Rn '[inputs]'
}

# [{session, name, kind}] live claude sessions whose process tree sits under a zellij server.
# registry: ~/.claude/sessions/<pid>.json (undocumented, only read here).
# bg sessions run under the claude daemon, so they never match.
claude_panes() {
  local f pid q cmd
  for f in "$CS"/*.json; do
    [ -e "$f" ] || continue
    pid=$(basename "$f" .json)
    kill -0 "$pid" 2>/dev/null || continue
    q=$pid
    for _ in 1 2 3 4 5 6 7 8; do
      q=$(ps -o ppid= -p "$q" 2>/dev/null | tr -d ' ')
      { [ -z "$q" ] || [ "$q" -le 1 ]; } && break
      cmd=$(ps -o command= -p "$q" 2>/dev/null)
      case "$cmd" in
        *"zellij --server "*)
          printf '%s\t%s\t%s\n' "${cmd##*/}" \
            "$("$JQ" -r '.name // "claude"' "$f")" "$("$JQ" -r '.kind // ""' "$f")"
          break ;;
      esac
    done
  done | "$JQ" -Rn '[inputs | split("\t") | {session: .[0], name: .[1], kind: .[2]}]'
}

# [{session, id}] kitty windows. zellij titles them "<session> | <pane title>".
windows() {
  "$AERO" list-windows --all --format '%{window-id}|%{app-name}|%{window-title}' 2>/dev/null | "$JQ" -Rn '
    [inputs | split("|") | select(.[1] == "kitty")
      | {id: (.[0] | tonumber), title: (.[2:] | join("|"))}
      | select(.title | test(" \\| "))
      | {session: (.title | split(" | ")[0]), id}]'
}

# {live:[...], exited:[...]}, newest first.
# row: {name, age, state: attached|detached|exited, claude:[name], window: id|null}
list() {
  "$JQ" -n \
    --argjson z   "$(orempty "$(zsessions)")" \
    --argjson att "$(orempty "$(attached)")" \
    --argjson cl  "$(orempty "$(claude_panes)")" \
    --argjson win "$(orempty "$(windows)")" '
    [ $z[] | . as $s |
      { name, age,
        state: (if .exited then "exited"
                elif ($att | any(. == $s.name)) then "attached"
                else "detached" end),
        claude: [ $cl[] | select(.session == $s.name) | .name ],
        window: ([ $win[] | select(.session == $s.name) | .id ] | first) } ]
    | reverse
    | { live:   map(select(.state != "exited")),
        exited: map(select(.state == "exited")) }'
}

attach() { nohup "$KITTY" -e /bin/zsh -lc "$Z attach '$1'" >/dev/null 2>&1 & }

case "${1:-list}" in
  list)   list ;;
  focus)  valid "${2:-}"
          id=$(windows | "$JQ" -r --arg n "$2" '[.[] | select(.session == $n) | .id][0] // empty')
          if [ -n "$id" ]; then "$AERO" focus --window-id "$id"; else attach "$2"; fi
          list ;;
  attach) valid "${2:-}"; attach "$2"; list ;;
  delete) valid "${2:-}"
          "$Z" delete-session "$2" >/dev/null 2>&1   # exited only, no --force
          list ;;
  *)      echo "usage: sessions.sh list|focus <name>|attach <name>|delete <name>" >&2; exit 2 ;;
esac
