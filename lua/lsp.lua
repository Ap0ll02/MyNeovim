-- mason setup
local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
  vim.notify("Failed to load mason", vim.log.levels.ERROR)
  return
end

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- mason-lspconfig setup
local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_lspconfig_ok then
  vim.notify("Failed to load mason-lspconfig", vim.log.levels.ERROR)
  return
end

mason_lspconfig.setup({
  ensure_installed = { 'pylsp', 'lua_ls', 'rust_analyzer' },
})

-- default capabilities for completion
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  (pcall(require, "cmp_nvim_lsp") and require("cmp_nvim_lsp").default_capabilities()) or {}
)

-- on_attach function for keybindings
local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end
  bufmap("n", "gd", vim.lsp.buf.definition)
  bufmap("n", "K", vim.lsp.buf.hover)
  bufmap("n", "<leader>rn", vim.lsp.buf.rename)
  bufmap("n", "<leader>ca", vim.lsp.buf.code_action)
end

-- define LSP settings
local server_settings = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    },
  },
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          pyflakes = { enabled = true },
          pycodestyle = { enabled = false },
        },
      },
    },
  },
  rust_analyzer = {}, -- empty, uses defaults
}

-- filter out unwanted servers (e.g., stylua is a formatter, not an LSP)
local ignored_servers = { 'stylua', 'omnisharp_mono' }

-- setup installed servers using vim.lsp.config
for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
  if not vim.tbl_contains(ignored_servers, server_name) then
    local config = vim.tbl_deep_extend(
      "force",
      { capabilities = capabilities, on_attach = on_attach },
      server_settings[server_name] or {}
    )
    local ok, server_config = pcall(vim.lsp.config, server_name)
    if ok and server_config then
      vim.lsp.start(server_config(config))
    else
      -- vim.notify("No config found for LSP: " .. server_name, vim.log.levels.WARN)
    end
  end
end

vim.notify("✅ LSPs initialized", vim.log.levels.INFO)
