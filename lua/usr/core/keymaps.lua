vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Hide search highlights" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
vim.keymap.set("n", "<C-b>", "<C-b>zz", { desc = "Page up" })
vim.keymap.set("n", "<C-f>", "<C-f>zz", { desc = "Page down" })
vim.keymap.set("n", "H", "zH", { desc = "Half page left" })
vim.keymap.set("n", "L", "zL", { desc = "Half page right" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next occurrence" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous occurrence" })

vim.keymap.set("i", "<C-c>", "<Esc>")
-- vim.keymap.set("i", "jj", "<Esc>")
-- vim.keymap.set("i", "kj", "<Esc>")

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank into system clipboard" })
vim.keymap.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" })

vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" })

vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "single" })
end, {
    desc = "Show documentation for what is under cursor"
})

vim.keymap.set("n", "gK", function()
    local new_config = not vim.diagnostic.config().virtual_lines
    local text = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_lines = new_config, virtual_text = text })
end, { desc = "Toggle diagnostics virtual lines" })
