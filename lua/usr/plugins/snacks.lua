return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
        zen = {
            toggles = {
                dim = false,
                git_blame = false,
                git_signs = false,
                diagnostics = false,
            },
            win = {
                backdrop = {
                    bg = "#1e1e2e",
                    blend = 0,
                    transparent = false
                }
            }
        },
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        explorer = { enabled = false },
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
        },
        input = { enabled = false },
        picker = {
            actions = {
                pick_win = {},
            },
            previewers = {
                diff = {
                    builtin = false,
                    cmd = { "delta" },
                },
            },
            ui_select = true,
            enabled = true,
            win = {
                input = {
                    keys = {
                        ["\\"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
                    },
                },
                list = {
                    keys = {
                        ["\\"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
                    },
                },
            },
        },
        notifier = { enabled = false },
        quickfile = { enabled = false },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = true },
    },
    keys = {
        { "<leader>gg", function() Snacks.lazygit() end,                                                                    desc = "Lazygit", },
        { "<leader>bd", function() Snacks.bufdelete() end,                                                                  desc = "Delete Buffer", },
        { "<leader>ff", function() Snacks.picker.files() end,                                                               desc = "Find Files", },
        { "<leader>fg", function() Snacks.picker.grep() end,                                                                desc = "Grep", },
        { "<leader>fb", function() Snacks.picker.buffers() end,                                                             desc = "Buffers", },
        { "<leader>fa", function() Snacks.picker.git_files() end,                                                           desc = "Git Files", },
        { "<leader>fr", function() Snacks.picker.resume() end,                                                              desc = "Resume picker", },
        { "<leader>fh", function() Snacks.picker.help() end,                                                                desc = "Help Pages", },
        { "<leader>fd", function() Snacks.picker.diagnostics_buffer({ layout = { preset = "ivy", preview = "main" } }) end, desc = "Buffer Diagnostics", },
        { "<leader>fD", function() Snacks.picker.diagnostics({ layout = { preset = "ivy", preview = "main" } }) end,        desc = "Workspace Diagnostics", },
        { "<leader>ft", function() Snacks.picker.todo_comments({ layout = { preset = "ivy", preview = "main" } }) end,      desc = "Workspace TODOs", },
        { "<leader>fs", function() Snacks.picker.lsp_symbols({ layout = { preset = "right", preview = "main", } }) end,     desc = "LSP Buffer Symbols", },
        { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end,                                               desc = "LSP Workspace Symbols", },
        { "gd",         function() Snacks.picker.lsp_definitions() end,                                                     desc = "LSP Definitions", },
        { "gD",         function() Snacks.picker.lsp_declarations() end,                                                    desc = "LSP Declarations", },
        { "gR",         function() Snacks.picker.lsp_references() end,                                                      desc = "LSP References", },
        { "gi",         function() Snacks.picker.lsp_implementations() end,                                                 desc = "LSP Implementations", },
        { "gt",         function() Snacks.picker.lsp_type_definitions() end,                                                desc = "LSP Type Definitions", },
        { "<leader>ss", function() Snacks.scratch() end,                                                                    desc = "Toggle Scratch Buffer" },
        { "<leader>sl", function() Snacks.scratch.select() end,                                                             desc = "Select Scratch Buffer" },
        { "<leader>z",  function() Snacks.zen() end,                                                                        desc = "Toggle Zen Mode" },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                Snacks.toggle.option("relativenumber", { name = "Relative Numbers" }):map("<leader>tr")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
                Snacks.toggle.option("list", { name = "List (Visible Whitespaces)" }):map("<leader>ts")

                Snacks.toggle.new({
                    id = "git_blame",
                    name = "Git Blame",
                    get = function()
                        return require("gitsigns.config").config.current_line_blame
                    end,
                    set = function(state)
                        require("gitsigns").toggle_current_line_blame(state)
                    end
                }):map("<leader>tb")

                Snacks.toggle.new({
                    id = "git_signs",
                    name = "Git Signs",
                    get = function()
                        return require("gitsigns.config").config.signcolumn
                    end,
                    set = function(state)
                        require("gitsigns").toggle_signs(state)
                    end
                }):map("<leader>tg")

                Snacks.toggle.new({
                    id = "format_on_save",
                    name = "Format On Save",
                    get = function()
                        return not vim.g.disable_autoformat
                    end,
                    set = function(state)
                        vim.g.disable_autoformat = not state
                    end
                }):map("<leader>tt")

                Snacks.toggle.new({
                    id = "format_on_save_buffer",
                    name = "Format On Save (Buffer)",
                    get = function()
                        return not vim.b.disable_autoformat
                    end,
                    set = function(state)
                        vim.b.disable_autoformat = not state
                    end
                }):map("<leader>tf")

                Snacks.toggle.new({
                    id = "inlay_hints",
                    name = "Inlay Hints",
                    get = vim.lsp.inlay_hint.is_enabled,
                    set = function(state)
                        vim.lsp.inlay_hint.enable(state)
                    end
                }):map("<leader>ti")

                Snacks.toggle.new({
                    id = "treesitter_context",
                    name = "Context",
                    get = function()
                        return require("treesitter-context").enabled()
                    end,
                    set = function(state)
                        if state then
                            require("treesitter-context").enable()
                        else
                            require("treesitter-context").disable()
                        end
                    end
                }):map("<leader>tc")
            end,
        })
    end,
}
