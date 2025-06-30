return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-web-devicons",
    },
    cmd = { "NvimTreeToggle" },
    keys = {
        { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    },
    config = function()
        local function pickWin()
            return Snacks.picker.util.pick_win({
                filter = function(win, buf)
                    return not vim.bo[buf].filetype:find("^NvimTree")
                end,
            })
        end

        local nvimtree = require("nvim-tree")

        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({
            disable_netrw = true,
            view = {
                width = function()
                    return math.floor(vim.opt.columns:get() * 0.2)
                end,
                signcolumn = "no",
            },
            renderer = {
                root_folder_label = false,
                group_empty = true,
                full_name = true,
                indent_markers = {
                    enable = true,
                },
                special_files = {
                    "Cargo.toml",
                    "CMakeLists.txt",
                    "build.gradle",
                    "settings.gradle",
                    "pom.xml",
                    "package.json",
                    "Makefile",
                    "README.md",
                    "readme.md",
                }
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                api.config.mappings.default_on_attach(bufnr)

                vim.keymap.del("n", "<C-]>", { buffer = bufnr })
                vim.keymap.set("n", "<C-t>", api.tree.change_root_to_node, opts("CD"))
                vim.keymap.set("n", "<C-c>", function() end, { buffer = bufnr })
            end,
            actions = {
                open_file = {
                    window_picker = {
                        picker = pickWin,
                    },
                },
            },
        })
    end,
}
