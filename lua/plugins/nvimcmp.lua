return
{
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',      -- LSP completions
    'hrsh7th/cmp-buffer',        -- Buffer completions
    'hrsh7th/cmp-path',          -- File system paths
    'L3MON4D3/LuaSnip',          -- Snippet engine (optional but useful)
    'saadparwaiz1/cmp_luasnip',  -- Snippet completions
    'onsails/lspkind.nvim',      -- Fancy icons
    -- OPTIONAL eye-candy or enhancements:
    -- 'yorickpeterse/nvim-cmp-blink',
  },
  config = function()
    local cmp = require('cmp')
    local lspkind = require('lspkind')

    cmp.setup({
      formatting = {
        format = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 }),
      },
      window = {
          completion = cmp.config.window.bordered({ border = "rounded" }),
          documentation = cmp.config.window.bordered({ border = "rounded" }),

      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
      }),
    })
  end,
}
