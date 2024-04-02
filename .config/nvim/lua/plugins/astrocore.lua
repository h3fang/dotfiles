-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    vim.list_extend(opts.servers, {
      "pyright",
      "rust_analyzer",
    })
  end,
}
