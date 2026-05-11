return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "html", "css", "scss", "less",
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "vue", "svelte", "astro",
  },
  root_markers = {
    "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs",
    "tailwind.config.ts", "postcss.config.js", "postcss.config.cjs",
    "postcss.config.ts", "package.json", ".git",
  },
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "classList", "ngClass" },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning",
      },
      validate = true,
    },
  },
}
