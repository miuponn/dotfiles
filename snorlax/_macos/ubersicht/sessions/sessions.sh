#!/bin/bash
# sessions panel backend for index.jsx.
# absolute paths everywhere: übersicht runs commands with a minimal PATH.
set -uo pipefail
Z=/opt/homebrew/bin/zellij
JQ=/opt/homebrew/bin/jq
KITTY=/opt/homebrew/bin/kitty

valid() { [[ "${1:-}" =~ ^[A-Za-z0-9._-]+$ ]] || { echo "bad session name" >&2; exit 2; }; }

# {live:[{name,age}], exited:[{name,age}]}, newest first
list() {
  "$Z" list-sessions -n 2>/dev/null | "$JQ" -Rn '
    [inputs | select(test("\\[Created")) |
      { name: (split(" ")[0]),
        age: (((capture("Created (?<a>[0-9]+[a-z]+)") | .a) // "")
              | sub("years?";"y") | sub("months?";"mo") | sub("days?";"d")),
        exited: test("EXITED") }]
    | reverse
    | { live: map(select(.exited | not) | del(.exited)),
        exited: map(select(.exited) | del(.exited)) }'
}

case "${1:-list}" in
  list)   list ;;
  attach) valid "${2:-}"
          # attach also resurrects an exited session
          nohup "$KITTY" -e /bin/zsh -lc "$Z attach '$2'" >/dev/null 2>&1 &
          list ;;
  delete) valid "${2:-}"
          "$Z" delete-session "$2" >/dev/null 2>&1   # exited only, no --force
          list ;;
  *)      echo "usage: sessions.sh list|attach <name>|delete <name>" >&2; exit 2 ;;
esac
