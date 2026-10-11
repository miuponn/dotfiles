return {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = {
    "html", "css", "scss", "less", "sass",
    "javascriptreact", "typescriptreact",
    "vue", "svelte", "astro",
  },
  root_markers = { "package.json", ".git" },
  init_options = {
    showAbbreviationSuggestions = true,
    showExpandedAbbreviation = "always",
    showSuggestionsAsSnippets = true,
  },
}
