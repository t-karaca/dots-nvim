require("usr.core.options")
require("usr.core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { import = "usr.plugins" },
    { import = "usr.lsp" },
}, {
    install = {
        colorscheme = { "catppuccin" },
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        notify = false,
    },
    ui = {
        custom_keys = {
            ["<C-h>"] = { function() end },
            ["<C-j>"] = { function() end },
            ["<C-k>"] = { function() end },
            ["<C-l>"] = { function() end },
        }
    },
})
