---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      inlay_hints = true,
    },
    formatting = {
      format_on_save = false,
    },
    servers = { "rust_analyzer", "pyright" },
  },
}
