---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    opts {
      features = {
        inlay_hints = true,
      },
      formating = {
        format_on_save = false,
      },
      servers = { "rust_analyzer" },
    }
  end,
}
