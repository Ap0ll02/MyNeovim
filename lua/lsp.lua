-- plugins/lsp.lua (Lazy setup)
return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pylsp", "rust_analyzer" },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig") -- required for server registration

      local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        cmp_ok and cmp_nvim_lsp.default_capabilities() or {}
      )

      local on_attach = function(_, bufnr)
        local bufmap = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
        end
        bufmap("n", "gd", vim.lsp.buf.definition)
        bufmap("n", "K", vim.lsp.buf.hover)
        bufmap("n", "<leader>rn", vim.lsp.buf.rename)
        bufmap("n", "<leader>ca", vim.lsp.buf.code_action)
      end

      -- server-specific settings
      local servers = {
        lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } } },
        pylsp = { settings = { pylsp = { plugins = { pyflakes = { enabled = true }, pycodestyle = { enabled = false } } } } },
        rust_analyzer = {},
      }

      -- **Setup each server using the canonical setup call**
      for name, cfg in pairs(servers) do
        lspconfig[name].setup(vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
        }, cfg))
      end
    end,
  },
}

