return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
        explorer = { enabled = false },
        input = { enabled = false },
        quickfile = { enabled = false },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        dashboard = { enabled = true },
        bigfile = { enabled = true },
        words = { enabled = true },
        notifier = {
            enabled = true,
            top_down = false,
            margin = { bottom = 2, right = 2 },
        },
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
        },
        zen = {
            show = {
                statusline = true,
            },
            toggles = {
                dim = false,
                git_blame = false,
                git_signs = false,
                treesitter_context = false,
            },
            win = {
                width = 0.76,
                col = 0.25,
                backdrop = {
                    bg = "#1e1e2e",
                    blend = 0,
                    transparent = false
                }
            }
        },
        picker = {
            ui_select = true,
            enabled = true,
            previewers = {
                diff = {
                    builtin = false,
                    cmd = { "delta" },
                },
            },
            actions = {
                pick_or_confirm = function(picker, item)
                    if not item then
                        return
                    end

                    if not item.file or picker.opts.layout.preview == "main" or picker.opts.confirm then
                        picker:action("confirm")
                        return
                    end

                    -- cannot configure filter directly, code is copy paste
                    if not picker.layout.split then
                        picker.layout:hide()
                    end
                    local win = Snacks.picker.util.pick_win({
                        main = picker.main,
                        filter = require("usr.utils").windowFilter
                    })
                    if not win then
                        if not picker.layout.split then
                            picker.layout:unhide()
                        end
                        return true
                    end
                    picker.main = win
                    if not picker.layout.split then
                        vim.defer_fn(function()
                            if not picker.closed then
                                picker.layout:unhide()
                            end
                        end, 100)
                    end

                    picker:action("jump")
                end,
            },
            win = {
                input = {
                    keys = {
                        ["<CR>"] = { "pick_or_confirm", mode = { "n", "i" } },
                    },
                },
                list = {
                    keys = {
                        ["<CR>"] = { "pick_or_confirm", mode = { "n", "i" } },
                    },
                },
            },
        },
    },
    keys = {
        { "<leader>bd", function() Snacks.bufdelete() end,                                                                  desc = "Delete Buffer", },
        { "<leader>ff", function() Snacks.picker.files() end,                                                               desc = "Find Files", },
        { "<leader>fg", function() Snacks.picker.grep() end,                                                                desc = "Grep", },
        { "<leader>fb", function() Snacks.picker.buffers({ nofile = true }) end,                                            desc = "Buffers", },
        { "<leader>fa", function() Snacks.picker.git_files() end,                                                           desc = "Git Files", },
        { "<leader>fr", function() Snacks.picker.resume() end,                                                              desc = "Resume picker", },
        { "<leader>fh", function() Snacks.picker.help() end,                                                                desc = "Help Pages", },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,                             desc = "Config Files", },
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
        { "<leader>sn", function() Snacks.notifier.show_history() end,                                                      desc = "Show notifier history" },
        { "<leader>z",  function() Snacks.zen() end,                                                                        desc = "Toggle Zen Mode" },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                Snacks.toggle.diagnostics():map("<leader>td")
                Snacks.toggle.inlay_hints():map("<leader>ti")

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
