#!/usr/bin/env python3
import argparse
import json
import shutil
import sys
from pathlib import Path

home = Path.home()
version = "0.1.0"
variants = {
    "Grove": ".theme-dark",
    "Grove Nocturne": ".theme-dark.grove-nocturne",
    "Grove Light": ".theme-light",
    "Grove Mist": ".theme-light.grove-mist",
}
rgb_tokens = ["pink", "orange", "yellow", "sage", "teal", "blue", "lavender"]


def hex_color(value):
    value = value.lower()
    return value[:7] if len(value) == 9 and value.endswith("ff") else value


def rgb_triplet(value):
    value = value.lstrip("#")
    return f"{int(value[0:2], 16)}, {int(value[2:4], 16)}, {int(value[4:6], 16)}"


def tokens(theme):
    style = theme["style"]
    syntax = style["syntax"]
    players = style["players"]
    ui = lambda key: hex_color(style[key])
    code = lambda key: hex_color(syntax[key]["color"])
    return {
        "base": ui("background"),
        "panel": ui("panel.background"),
        "surface": ui("surface.background"),
        "editor": ui("editor.background"),
        "elevated": ui("elevated_surface.background"),
        "line": ui("editor.active_line.background"),
        "element": ui("element.background"),
        "hover": ui("element.hover"),
        "active": ui("element.active"),
        "border": ui("border"),
        "border-variant": ui("border.variant"),
        "border-focused": ui("border.focused"),
        "border-selected": ui("border.selected"),
        "text": ui("text"),
        "text-strong": code("emphasis.strong"),
        "muted": ui("text.muted"),
        "faint": ui("text.placeholder"),
        "disabled": ui("text.disabled"),
        "teal": ui("text.accent"),
        "teal-hover": ui("link_text.hover"),
        "teal-strong": hex_color(players[0]["cursor"]),
        "title": code("title"),
        "selection": hex_color(players[0]["selection"]),
        "lavender": code("keyword"),
        "yellow": ui("warning"),
        "orange": code("number"),
        "peach": code("constant"),
        "sage": code("string"),
        "blue": code("property"),
        "link-uri": code("link_uri"),
        "lime": ui("success"),
        "lime-bright": hex_color(players[2]["background"]),
        "pink": ui("error"),
        "attribute": code("attribute"),
        "operator": code("operator"),
        "punctuation": code("punctuation"),
        "comment": code("comment"),
        "search-background": ui("search.match_background"),
        "pink-background": ui("error.background"),
        "yellow-background": ui("warning.background"),
        "lavender-background": ui("hint.background"),
        "scrollbar": ui("scrollbar.thumb.background"),
        "scrollbar-hover": ui("scrollbar.thumb.hover_background"),
    }


def palette_block(selector, palette):
    lines = [f"body{selector} {{"]
    lines += [f"  --grove-{key}: {value};" for key, value in palette.items()]
    lines += [f"  --grove-{key}-rgb: {rgb_triplet(palette[key])};" for key in rgb_tokens + ["text"]]
    lines.append("}")
    return "\n".join(lines)

settings = """/* @settings

name: Grove
id: grove
settings:
    -
        id: grove-dark-variant
        title: Dark variant
        description: used when obsidian is in dark mode
        type: class-select
        allowEmpty: false
        default: grove-dark
        options:
            -
                label: Grove
                value: grove-dark
            -
                label: Grove Nocturne
                value: grove-nocturne
    -
        id: grove-light-variant
        title: Light variant
        description: used when obsidian is in light mode
        type: class-select
        allowEmpty: false
        default: grove-light
        options:
            -
                label: Grove Light
                value: grove-light
            -
                label: Grove Mist
                value: grove-mist
    -
        id: grove-translucency
        title: Translucency
        description: only applies with Appearance > Translucent window on
        type: heading
        level: 2
        collapsed: false
    -
        id: grove-chrome-opacity-dark
        title: Chrome opacity (dark)
        description: sidebars, ribbon, tab bar, status bar
        type: variable-number-slider
        default: 80
        min: 30
        max: 100
        step: 2
        format: '%'
    -
        id: grove-reading-opacity-dark
        title: Note pane opacity (dark)
        type: variable-number-slider
        default: 90
        min: 60
        max: 100
        step: 2
        format: '%'
    -
        id: grove-chrome-opacity-light
        title: Chrome opacity (light)
        type: variable-number-slider
        default: 82
        min: 30
        max: 100
        step: 2
        format: '%'
    -
        id: grove-reading-opacity-light
        title: Note pane opacity (light)
        type: variable-number-slider
        default: 100
        min: 60
        max: 100
        step: 2
        format: '%'

*/"""

roles = """
body.theme-dark, body.theme-light {
  --color-base-00: var(--grove-editor);
  --color-base-05: var(--grove-line);
  --color-base-10: var(--grove-surface);
  --color-base-20: var(--grove-panel);
  --color-base-25: var(--grove-element);
  --color-base-30: var(--grove-border);
  --color-base-35: var(--grove-active);
  --color-base-40: var(--grove-border-focused);
  --color-base-50: var(--grove-faint);
  --color-base-60: var(--grove-muted);
  --color-base-70: var(--grove-muted);
  --color-base-100: var(--grove-text);
  --mono-rgb-100: var(--grove-text-rgb, 228, 235, 228);
  --color-red: var(--grove-pink);
  --color-orange: var(--grove-orange);
  --color-yellow: var(--grove-yellow);
  --color-green: var(--grove-sage);
  --color-cyan: var(--grove-teal);
  --color-blue: var(--grove-blue);
  --color-purple: var(--grove-lavender);
  --color-pink: var(--grove-pink);
  --color-red-rgb: var(--grove-pink-rgb);
  --color-orange-rgb: var(--grove-orange-rgb);
  --color-yellow-rgb: var(--grove-yellow-rgb);
  --color-green-rgb: var(--grove-sage-rgb);
  --color-cyan-rgb: var(--grove-teal-rgb);
  --color-blue-rgb: var(--grove-blue-rgb);
  --color-purple-rgb: var(--grove-lavender-rgb);
  --color-pink-rgb: var(--grove-pink-rgb);
  --color-accent: var(--grove-teal);
  --color-accent-1: var(--grove-teal);
  --color-accent-2: var(--grove-teal-hover);
  --interactive-accent: var(--grove-teal);
  --interactive-accent-hover: var(--grove-teal-hover);
  --text-on-accent: var(--grove-base);
  --text-selection: var(--grove-selection);
  --caret-color: var(--grove-teal-strong);
  --background-primary: var(--grove-editor);
  --background-primary-alt: var(--grove-line);
  --background-secondary: var(--grove-panel);
  --background-secondary-alt: var(--grove-base);
  --background-modifier-border: var(--grove-border);
  --background-modifier-border-hover: var(--grove-border-focused);
  --background-modifier-border-focus: var(--grove-border-selected);
  --background-modifier-form-field: var(--grove-base);
  --background-modifier-error: var(--grove-pink);
  --background-modifier-success: var(--grove-lime);
  --interactive-normal: var(--grove-element);
  --interactive-hover: var(--grove-active);
  --divider-color: var(--grove-border-variant);
  --titlebar-background: var(--grove-base);
  --titlebar-background-focused: var(--grove-base);
  --ribbon-background: var(--grove-base);
  --ribbon-background-collapsed: var(--grove-base);
  --status-bar-background: var(--grove-base);
  --status-bar-border-color: var(--grove-border-variant);
  --tab-container-background: var(--grove-panel);
  --tab-background-active: var(--grove-editor);
  --tab-text-color-focused-active: var(--grove-text);
  --tab-text-color-focused-active-current: var(--grove-text);
  --modal-background: var(--grove-editor);
  --menu-background: var(--grove-elevated);
  --prompt-background: var(--grove-elevated);
  --suggestion-background: var(--grove-elevated);
  --background-modifier-cover: color-mix(in srgb, var(--grove-base) 60%, transparent);
  --text-normal: var(--grove-text);
  --text-muted: var(--grove-muted);
  --text-faint: var(--grove-faint);
  --text-accent: var(--grove-teal);
  --text-accent-hover: var(--grove-teal-hover);
  --text-error: var(--grove-pink);
  --text-warning: var(--grove-yellow);
  --text-success: var(--grove-lime);
  --icon-color: var(--grove-muted);
  --icon-color-hover: var(--grove-text);
  --icon-color-active: var(--grove-teal);
  --icon-color-focused: var(--grove-text);
  --nav-item-color-active: var(--grove-teal-strong);
  --nav-item-color-selected: var(--grove-text);
  --nav-collapse-icon-color: var(--grove-faint);
  --indentation-guide-color: var(--grove-border-variant);
  --indentation-guide-color-active: var(--grove-border);
  --h1-color: var(--grove-title);
  --h2-color: var(--grove-teal);
  --h3-color: var(--grove-lavender);
  --h4-color: var(--grove-yellow);
  --h5-color: var(--grove-orange);
  --h6-color: var(--grove-muted);
  --h1-weight: 700;
  --bold-color: var(--grove-text-strong);
  --italic-color: var(--grove-text);
  --link-color: var(--grove-teal);
  --link-color-hover: var(--grove-teal-hover);
  --link-external-color: var(--grove-link-uri);
  --link-external-color-hover: var(--grove-blue);
  --link-unresolved-color: var(--grove-faint);
  --link-unresolved-opacity: 1;
  --link-unresolved-decoration-style: dashed;
  --link-unresolved-decoration-color: var(--grove-faint);
  --tag-color: var(--grove-teal);
  --tag-color-hover: var(--grove-teal-hover);
  --blockquote-border-color: var(--grove-border-focused);
  --hr-color: var(--grove-border);
  --checkbox-color: var(--grove-teal);
  --checkbox-color-hover: var(--grove-teal-hover);
  --checkbox-border-color: var(--grove-faint);
  --checkbox-border-color-hover: var(--grove-muted);
  --checkbox-marker-color: var(--grove-base);
  --checklist-done-color: var(--grove-faint);
  --embed-border-start: 2px solid var(--grove-border-focused);
  --table-border-color: var(--grove-border);
  --metadata-border-color: var(--grove-border-variant);
  --scrollbar-thumb-bg: var(--grove-scrollbar);
  --scrollbar-active-thumb-bg: var(--grove-scrollbar-hover);
  --code-background: var(--grove-panel);
  --code-normal: var(--grove-text);
  --code-comment: var(--grove-comment);
  --code-function: var(--grove-teal);
  --code-important: var(--grove-peach);
  --code-keyword: var(--grove-lavender);
  --code-operator: var(--grove-operator);
  --code-property: var(--grove-blue);
  --code-punctuation: var(--grove-punctuation);
  --code-string: var(--grove-sage);
  --code-tag: var(--grove-teal);
  --code-value: var(--grove-orange);
  --graph-node: var(--grove-muted);
  --graph-node-focused: var(--grove-teal-strong);
  --graph-node-tag: var(--grove-lavender);
  --graph-node-attachment: var(--grove-yellow);
  --graph-node-unresolved: var(--grove-faint);
  --graph-line: var(--grove-border);
  --graph-text: var(--grove-text);
  --callout-default: var(--grove-teal);
  --callout-info: var(--grove-teal);
  --callout-todo: var(--grove-teal);
  --callout-summary: var(--grove-blue);
  --callout-tip: var(--grove-sage);
  --callout-important: var(--grove-lavender);
  --callout-success: var(--grove-lime);
  --callout-question: var(--grove-yellow);
  --callout-warning: var(--grove-yellow);
  --callout-fail: var(--grove-pink);
  --callout-error: var(--grove-pink);
  --callout-bug: var(--grove-pink);
  --callout-example: var(--grove-peach);
  --callout-quote: var(--grove-muted);
}

body.theme-dark {
  --tag-background: color-mix(in srgb, var(--grove-teal) 12%, transparent);
  --tag-background-hover: color-mix(in srgb, var(--grove-teal) 20%, transparent);
  --tag-border-color: color-mix(in srgb, var(--grove-teal) 18%, transparent);
  --nav-item-background-active: color-mix(in srgb, var(--grove-teal) 14%, transparent);
  --nav-item-background-selected: color-mix(in srgb, var(--grove-teal) 18%, transparent);
  --nav-item-background-hover: color-mix(in srgb, var(--grove-text) 6%, transparent);
  --background-modifier-hover: color-mix(in srgb, var(--grove-text) 6%, transparent);
  --background-modifier-active-hover: color-mix(in srgb, var(--grove-teal) 14%, transparent);
  --highlight-opacity: 26%;
  --highlight-background-red: color-mix(in srgb, var(--grove-pink) var(--highlight-opacity), var(--grove-pink-background));
  --highlight-background-orange: color-mix(in srgb, var(--grove-orange) var(--highlight-opacity), var(--grove-search-background));
  --highlight-background-yellow: color-mix(in srgb, var(--grove-yellow) var(--highlight-opacity), var(--grove-yellow-background));
  --highlight-background-green: color-mix(in srgb, var(--grove-sage) var(--highlight-opacity), transparent);
  --highlight-background-blue: color-mix(in srgb, var(--grove-blue) var(--highlight-opacity), transparent);
  --highlight-background-purple: color-mix(in srgb, var(--grove-lavender) var(--highlight-opacity), transparent);
  --highlight-mix-blend-mode: normal;
}

body.theme-light {
  --tag-background: color-mix(in srgb, var(--grove-teal) 12%, var(--grove-editor));
  --tag-background-hover: color-mix(in srgb, var(--grove-teal) 20%, var(--grove-editor));
  --tag-border-color: color-mix(in srgb, var(--grove-teal) 22%, var(--grove-editor));
  --nav-item-background-active: color-mix(in srgb, var(--grove-teal) 14%, var(--grove-panel));
  --nav-item-background-selected: color-mix(in srgb, var(--grove-teal) 18%, var(--grove-panel));
  --nav-item-background-hover: var(--grove-hover);
  --background-modifier-hover: color-mix(in srgb, var(--grove-text) 6%, transparent);
  --background-modifier-active-hover: color-mix(in srgb, var(--grove-teal) 14%, var(--grove-panel));
  --highlight-opacity: 24%;
  --highlight-background-red: color-mix(in srgb, var(--grove-pink) var(--highlight-opacity), transparent);
  --highlight-background-orange: color-mix(in srgb, var(--grove-orange) var(--highlight-opacity), transparent);
  --highlight-background-yellow: color-mix(in srgb, var(--grove-yellow) var(--highlight-opacity), transparent);
  --highlight-background-green: color-mix(in srgb, var(--grove-sage) var(--highlight-opacity), var(--grove-editor));
  --highlight-background-blue: color-mix(in srgb, var(--grove-blue) var(--highlight-opacity), var(--grove-editor));
  --highlight-background-purple: color-mix(in srgb, var(--grove-lavender) var(--highlight-opacity), var(--grove-editor));
  --highlight-mix-blend-mode: normal;
}
"""

translucency = """
body.theme-dark {
  --grove-chrome-alpha: var(--grove-chrome-opacity-dark, 80%);
  --grove-reading-alpha: var(--grove-reading-opacity-dark, 90%);
}

body.theme-light {
  --grove-chrome-alpha: var(--grove-chrome-opacity-light, 82%);
  --grove-reading-alpha: var(--grove-reading-opacity-light, 100%);
}

body.is-translucent:not(.is-fullscreen) {
  --workspace-background-translucent: color-mix(in srgb, var(--grove-base) var(--grove-chrome-alpha), transparent);
  --grove-reading-background: color-mix(in srgb, var(--grove-editor) var(--grove-reading-alpha), transparent);
  --status-bar-background: transparent;
  --tab-container-background: transparent;
  --tab-background-active: var(--grove-reading-background);
  --titlebar-background: transparent;
  --titlebar-background-focused: transparent;
}

body.is-translucent:not(.is-fullscreen) .workspace-split.mod-root .view-content,
body.is-translucent:not(.is-fullscreen) .workspace-split.mod-root .view-header {
  background-color: var(--grove-reading-background);
}
"""

components = """
.workspace-leaf.mod-active .view-header {
  box-shadow: inset 0 -2px 0 var(--grove-teal);
}

.cm-s-obsidian span.cm-highlight.obsidian-search-match-highlight,
.cm-s-obsidian span.obsidian-search-match-highlight {
  background-color: var(--grove-search-background);
}

.cm-s-obsidian span.obsidian-search-match-highlight {
  box-shadow: 0 0 0 2px var(--grove-orange);
  mix-blend-mode: normal;
}

.search-result-file-matched-text {
  background-color: var(--grove-search-background);
  color: var(--grove-text);
  box-shadow: inset 0 -1px 0 var(--grove-orange);
}

.markdown-rendered .search-highlight > div {
  box-shadow: 0 0 0 2px var(--grove-orange);
  opacity: 0.8;
  mix-blend-mode: normal;
}

body.theme-dark .callout:is([data-callout="warning"], [data-callout="caution"], [data-callout="attention"],
  [data-callout="question"], [data-callout="help"], [data-callout="faq"]) {
  background-color: var(--grove-yellow-background);
}

body.theme-dark .callout:is([data-callout="danger"], [data-callout="error"], [data-callout="bug"],
  [data-callout="failure"], [data-callout="fail"], [data-callout="missing"]) {
  background-color: var(--grove-pink-background);
}

body.theme-dark .callout[data-callout="example"] {
  background-color: var(--grove-search-background);
}

.token.comment,
.cm-s-obsidian span.cm-comment,
.token.attr-name {
  font-style: italic;
}

.token.attr-name { color: var(--grove-attribute); }

.markdown-rendered .internal-link.is-unresolved,
.cm-s-obsidian .is-unresolved .cm-underline {
  text-decoration-style: dashed;
}
"""


def build(zed_path):
    themes = {theme["name"]: theme for theme in json.loads(Path(zed_path).read_text())["themes"]}
    missing = [name for name in variants if name not in themes]
    if missing:
        sys.exit(f"missing zed variants: {missing}")
    sections = [settings]
    sections += [palette_block(selector, tokens(themes[name])) for name, selector in variants.items()]
    sections += [roles, translucency, components]
    return "\n\n".join(section.strip("\n") for section in sections) + "\n"


def main():
    parser = argparse.ArgumentParser(description="generate the grove obsidian theme from the zed theme")
    parser.add_argument("--zed", default=str(home / ".config/zed/themes/grove.json"))
    parser.add_argument("--out", default=str(Path(__file__).resolve().parent / "Grove"))
    parser.add_argument("--install", help="vault path, copies Grove/ into <vault>/.obsidian/themes/")
    arguments = parser.parse_args()
    output = Path(arguments.out)
    output.mkdir(parents=True, exist_ok=True)
    (output / "theme.css").write_text(build(arguments.zed))
    manifest = {
        "name": "Grove",
        "version": version,
        "minAppVersion": "1.9.0",
        "author": "Miu G",
        "authorUrl": "https://github.com/miuponn",
    }
    (output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"wrote {output}/theme.css")
    if arguments.install:
        destination = Path(arguments.install).expanduser() / ".obsidian/themes/Grove"
        destination.mkdir(parents=True, exist_ok=True)
        for filename in ("theme.css", "manifest.json"):
            shutil.copy2(output / filename, destination / filename)
        print(f"installed -> {destination}")


if __name__ == "__main__":
    main()
