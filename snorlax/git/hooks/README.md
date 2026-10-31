# no-attribution commit hook

`commit-msg` strips ai attribution lines from commit messages. the script itself is gitignored and stays on this machine.

what it removes: lines matching `^co-authored-by:.*(claude|anthropic)`, `^claude-session:`, `generated with [claude code`, `^https://claude.ai/code/session` (case-insensitive), then `git stripspace`. human co-authors stay.

link.sh installs it in:

| repo | how |
|---|---|
| ~/dotfiles | repo-local `core.hooksPath = snorlax/git/hooks` |
| ~/repos/blog-site, ~/nix-config, ~/repos/qmk_firmware, ~/repos/base16-grove-scheme, ~/repos/ascii-stats | `.git/hooks/commit-msg` symlinked to this file, so each repo's other hooks still run |

every other repo keeps attribution. on a fresh clone the script is missing: recreate it from the rules above, then rerun link.sh.
check a repo: `git hook run commit-msg -- <file with a trailer>`. not covered: `--no-verify`, commits made on github.com or in cloud sandboxes.
