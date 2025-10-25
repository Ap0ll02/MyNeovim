return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "Mr-LLLLL/interestingwords.nvim" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "rose-pine", -- or "tokyonight", "dracula", "catppuccin", "auto"
      },
      sections = {
        -- your other sections...
        lualine_x = {
          {
            require("interestingwords").lualine_get,
            cond = require("interestingwords").lualine_has,
            color = { fg = "#ff9e64" },
          },
        },
      },
    })
  end,
}


