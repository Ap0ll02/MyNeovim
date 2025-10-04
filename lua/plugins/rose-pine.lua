-- lua/plugins/rose-pine.lua
return {
	"rose-pine/neovim",
    name = "rose-pine",
    config = function()
        vim.cmd("colorscheme rose-pine")
        require("rose-pine").setup({
            disable_background = true,
            disable_float_background = true
        })
    end
}
