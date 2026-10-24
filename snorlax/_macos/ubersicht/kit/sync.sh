#!/bin/bash
# vendor kit/frame.jsx into every widget that uses it.
#   sync.sh          copy + print md5s
#   sync.sh --check  exit 1 if any copy differs from the source (no writes)
# übersicht skips anything under /lib/ when looking for widgets, so lib/frame.jsx is never run on its own.
set -euo pipefail
KIT="$(cd "$(dirname "$0")" && pwd)"
SRC="$KIT/frame.jsx"
CONSUMERS=(
  "$KIT/../sessions"
  "$HOME/repos/pond-widget"
  "$HOME/repos/pokedoro"
)

sum() { md5 -q "$1" 2>/dev/null || md5sum "$1" | cut -d' ' -f1; }
want=$(sum "$SRC")
echo "source  $want  $SRC"
drift=0
for c in "${CONSUMERS[@]}"; do
  dst="$c/lib/frame.jsx"
  if [ "${1:-}" = "--check" ]; then
    have=$( [ -f "$dst" ] && sum "$dst" || echo missing )
    [ "$have" = "$want" ] && echo "ok      $have  $dst" || { echo "DRIFT   $have  $dst"; drift=1; }
  else
    mkdir -p "$c/lib"
    cp "$SRC" "$dst"
    echo "synced  $(sum "$dst")  $dst"
  fi
done
exit $drift
