---@module "lazy"
---@type LazyPluginSpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local treesitter = require("nvim-treesitter")
            local parsers = require("nvim-treesitter.parsers")

            vim.filetype.add({
                pattern = {
                    [".*/hypr/.*%.conf"] = "hyprlang"
                },
                filename = {
                    ["spring.factories"] = "jproperties",
                },
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "TSUpdate",
                callback = function()
                    parsers.testlang = {
                        install_info = {
                            path = '~/personal/tree-sitter-testlang',
                            queries = "queries",
                        },
                    }

                    vim.treesitter.language.register("testlang", "testlang")
                end
            })

            -- pre install all injectable languages since they will not be recognized for automatic installation
            treesitter.install({
                "gotmpl",
                "promql",
                "printf",
                "javadoc",
                "comment",
                "regex",
                "re2c",
                "doxygen",
                "vim",
                "jsdoc",
                "luadoc",
                "markdown_inline",
                "asm",
                "diff",
                "git_rebase",
                "disassembly",
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ctx)
                    local buf = ctx.buf
                    local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })

                    if filetype == "" or filetype == "scss" then
                        return
                    end

                    local parserName = vim.treesitter.language.get_lang(filetype)
                    if not parserName then
                        return
                    end

                    if not parsers[parserName] then
                        return
                    end

                    treesitter.install({ parserName }):await(function()
                        if not vim.api.nvim_buf_is_loaded(buf) then
                            return
                        end

                        vim.treesitter.start(buf)

                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end)
                end
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        ---@module 'nvim-treesitter-textobjects'
        ---@type TSTextObjects.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            select = {
                lookahead = true,
            },
        },
        keys = {
            {
                "af",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "function"
            },
            {
                "if",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "inner function"
            },
            {
                "ac",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@call.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "call"
            },
            {
                "ic",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@call.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "inner call"
            },
            {
                "aa",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@assignment.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "assignment"
            },
            {
                "ia",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@assignment.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "inner assignment"
            },
            {
                "ah",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@assignment.lhs", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "assignment lhs"
            },
            {
                "al",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@assignment.rhs", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "assignment rhs"
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                enable = true,
                multiwindow = false,
                max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to show for a single context
                trim_scope = "outer",
                mode = "topline",
                separator = nil,
                zindex = 10000,
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            })
        end,
    }
}
