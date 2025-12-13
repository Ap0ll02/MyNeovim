vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('config.lazy')
require('options')
require('colorscheme')
require('lsp') require('keymaps')

if vim.g.neovide then
    vim.o.guifont = "CodeNewRoman Nerd Font Mono:h28" -- text below applies for VimScript
    -- Helper function for transparency formatting
    local alpha = function()
        return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
    end
    -- g:neovide_opacity should be 0 if you want to unify transparency of content and title bar.
    vim.g.transparency = 0.98
    vim.g.neovide_background_color = "#103138"
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_remember_window_size = true
    if vim.fn.has("mac") == 1 then
        vim.g.neovide_window_blurred = true
        vim.g.neovide_floating_blur_amount_x = 2.0
        vim.g.neovide_floating_blur_amount_y = 2.0
    end
    vim.g.neovide_scale_factor = 1.0

    local function change_scale(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
    end

    -- macOS: Cmd + / Cmd -
    vim.keymap.set("n", "<D-=>", function()
        change_scale(0.1)
    end, { desc = "Neovide Zoom In" })

    vim.keymap.set("n", "<D-->", function()
        change_scale(-0.1)
    end, { desc = "Neovide Zoom Out" })

    vim.keymap.set("n", "<D-0>", function()
        vim.g.neovide_scale_factor = 1.0
    end, { desc = "Neovide Reset Zoom" })

    -- Linux / general: Ctrl + / Ctrl -
    vim.keymap.set("n", "<C-=>", function()
        change_scale(0.1)
    end, { desc = "Neovide Zoom In" })

    vim.keymap.set("n", "<C-->", function()
        change_scale(-0.1)
    end, { desc = "Neovide Zoom Out" })

    vim.keymap.set("n", "<C-0>", function()
        vim.g.neovide_scale_factor = 1.0
    end, { desc = "Neovide Reset Zoom" })
end
