local config = {
  header = {
    "AstroNvim",
  },
  -- Extend LSP configuration
  lsp = {
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false,
      },
    },
    -- enable servers that you already have installed without mason
    servers = {
      "pyright",
      "rust_analyzer",
    },
  },
  -- Configure plugins
  plugins = {
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "lua_ls",
        },
      },
    },
    {
      "jay-babu/mason-null-ls.nvim",
      config = function()
        require("mason-null-ls").setup {
          ensure_installed = { "stylua" },
        }
      end,
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      opts = function(_, config)
        local null_ls = require "null-ls"
        config.sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.formatting.clang_format,
        }
        return config
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = { "lua", "rust", "python", "c", "cpp" },
      },
    },
    {
      "ethanholz/nvim-lastplace",
      config = function()
        require("nvim-lastplace").setup {
          lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
          lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit", "alpha", "mason", "toggleterm", "lazy" },
          lastplace_open_folds = true,
        }
      end,
    },

    {
      "johnfrankmorgan/whitespace.nvim",
      config = function()
        require("whitespace-nvim").setup {
          highlight = "DiffDelete",
          ignored_filetypes = { "TelescopePrompt", "Trouble", "help", "alpha", "mason", "toggleterm", "lazy" },
        }
      end,
      lazy = false,
    },
    {
      "L3MON4D3/LuaSnip",
      config = function(plugin, opts)
        require "plugins.configs.luasnip" (plugin, opts)
        require("luasnip.loaders.from_vscode").lazy_load { paths = { "./lua/user/snippets" } }
      end,
    },
    {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      requires = { { "nvim-lua/plenary.nvim" } },
      config = function() require("crates").setup() end,
    },
  },
  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
  end,
}
return config
