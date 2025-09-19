---@module "lazy"
---@type LazyPluginSpec
return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        fuzzy = {
            implementation = "lua",
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        signature = {
            enabled = true,
            window = {
                border = "solid",
            },
        },
        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            per_filetype = {
                ["dap-repl"] = { "dap" },
                ["query"] = { "omni" },
            },
            providers = {
                lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
                dap = { name = "dap", module = "usr.dap-source", score_offset = 200 },
                snippets = {
                    should_show_items = function(ctx)
                        return ctx.trigger.initial_kind ~= 'trigger_character'
                    end,
                },
            },
        },
        keymap = {
            preset = "none",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<Tab>"] = { "accept", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },
            ["<C-e>"] = { "snippet_forward", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "show_signature", "hide_signature", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        },
        completion = {
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false,
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100,
                window = {
                    border = "solid",
                },
            },
            menu = {
                border = "solid",
                min_width = 30,
                max_height = 20,
                scrollbar = false,
                draw = {
                    padding = 1,
                    columns = {
                        { "kind_icon", "label", gap = 1 },
                        { "kind" },
                    },
                },
            },
            ghost_text = {
                enabled = true,
            },
        },
        cmdline = {
            keymap = {
                preset = "none",
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<CR>"] = { "accept_and_enter", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            },
            completion = {
                menu = {
                    auto_show = true,
                    draw = {
                        columns = {
                            { "kind_icon", "label", gap = 1 },
                        },
                    },
                },
                list = {
                    selection = {
                        auto_insert = true,
                        preselect = false,
                    },
                },
            },
        },
    },
}
