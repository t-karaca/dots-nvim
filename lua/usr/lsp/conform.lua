---@module "lazy"
---@type LazyPluginSpec
return {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                go = { "goimports" },
                java = { "palantir-java-format" },
                -- java = { "google-java-format" },
                c = { "clang-format" },
                cpp = { "clang-format" },

                -- json = { "prettierd" },
                -- yaml = { "yamlfmt" },

                -- lua = { "stylua" },
                bash = { "shfmt" },
                sh = { "shfmt" },
                sql = { "sqlfmt" },

                javascript = { "prettierd" },
                typescript = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescriptreact = { "prettierd" },
                css = { "prettierd" },
                scss = { "prettierd" },
                html = { "prettierd" },
                htmlangular = { "prettierd" },
            },
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end

                return { timeout_ms = 1000, async = false, lsp_fallback = true }
            end,
            formatters = {
                prettier = {
                    options = {
                        ft_parsers = {
                            htmlangular = "angular",
                        },
                    },
                },
                shfmt = {
                    inherit = true,
                    prepend_args = { "-i", "4" },
                },
                ["palantir-java-format"] = {
                    command = "palantir-java-format",
                    args = {
                        "--palantir",
                        "-",
                    },
                },
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })

        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })

        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })
    end,
}
