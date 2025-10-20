-- mason setup
require('mason').setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- mason-lspconfig setup
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = { 'pylsp', 'lua_ls', 'rust_analyzer' },
})

-- define LSP configs using the new API
vim.lsp.config["lua_ls"] = {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
}

vim.lsp.config["pylsp"] = {
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = true },
        pycodestyle = { enabled = false },
      },
    },
  },
}

-- default config if you want to apply capabilities, etc.
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  (pcall(require, "cmp_nvim_lsp") and require("cmp_nvim_lsp").default_capabilities()) or {}
)

-- auto-start installed servers
for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
  local config = vim.tbl_deep_extend(
    "force",
    { capabilities = capabilities },
    vim.lsp.config[server] or {}
  )
  vim.lsp.start(config)
end

