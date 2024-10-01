---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    opts.features.inlay_hints = true
    opts.formatting.format_on_save = false
    -- safely extend the servers list
    opts.servers = opts.servers or {}
    vim.list_extend(opts.servers, {
      "rust_analyzer",
      "pyright",
    })
  end,
}
