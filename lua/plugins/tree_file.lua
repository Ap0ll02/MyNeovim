return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- load immediately
    config = function()
      require("neo-tree").setup({
        filesystem = { follow_current_file = {enabled = true}, use_libuv_file_watcher = true },
        window = { position = "left", width = 19 },
      })

      -- Toggle Neo-tree
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

      -- Smart Tab switching between Neo-tree and last buffer
      vim.keymap.set("n", "<Tab>", function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match("neo%-tree") then
          vim.cmd("wincmd p")
        else
          vim.cmd("Neotree focus filesystem left")
        end
      end, { noremap = true, silent = true })
      vim.keymap.set("n", "<S-Tab>", "<C-w>p", { noremap = true, silent = true })

      -- Auto-quit if Neo-tree is the last window
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local wins = vim.api.nvim_list_wins()
          if #wins == 1 then
            local bufname = vim.api.nvim_buf_get_name(0)
            if bufname:match("neo%-tree") then
              vim.cmd("quit")
            end
          end
        end,
      })
    end
  }
}

