---@module "lazy"
---@type LazyPluginSpec[]
return {
    {
        "towolf/vim-helm",
        ft = "helm",
    },
    {
        "williamboman/mason.nvim",
        lazy = true,
        cmd = { "Mason", "MasonLog", "MasonInstall" },
        ---@module "mason"
        ---@type MasonSettings
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        }
    },
    {
        "cenk1cenk2/schema-companion.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        opts = {},
        keys = {
            { "<leader>fy", function() require("schema-companion").select_schema() end, desc = "Schemas" }
        }
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "b0o/schemastore.nvim",
            "williamboman/mason.nvim",
            "cenk1cenk2/schema-companion.nvim",
        },
        config = function()
            local schemaCompanion = require("schema-companion")
            local schemastore = require("schemastore")

            vim.lsp.config("clangd", {
                cmd = { "clangd", "--clang-tidy", "--completion-style=detailed" }
            })

            vim.lsp.config("angularls", {
                root_markers = { "angular.json", "nx.json", "package.json", ".git" }
            })

            vim.lsp.config("helm_ls", schemaCompanion.setup_client(
                schemaCompanion.adapters.helmls.setup({
                    sources = {
                        schemaCompanion.sources.matchers.kubernetes.setup({ version = "master" }),
                    },
                })
            ))

            local dapConfigSchema = {
                name = "DAP Config",
                description = "Debug adapter configuration",
                url = "https://raw.githubusercontent.com/mfussenegger/dapconfig-schema/master/dapconfig-schema.json",
                fileMatch = { ".vscode/launch.json", ".vscode/launch-*.json" },
            }

            local jsonSchemas = schemastore.json.schemas({ extra = { dapConfigSchema } })

            vim.lsp.config("jsonls", schemaCompanion.setup_client(
                schemaCompanion.adapters.jsonls.setup({
                    sources = {
                        schemaCompanion.sources.lsp.setup(),
                        schemaCompanion.sources.none.setup(),
                    },
                }),
                ---@diagnostic disable-next-line: missing-fields
                {
                    settings = {
                        json = {
                            schemas = jsonSchemas,
                            validate = { enable = true },
                        },
                    },
                })
            )

            vim.lsp.config("yamlls", schemaCompanion.setup_client(
                schemaCompanion.adapters.yamlls.setup({
                    sources = {
                        schemaCompanion.sources.matchers.kubernetes.setup({ version = "master" }),
                        schemaCompanion.sources.lsp.setup(),
                    },
                }),
                ---@diagnostic disable-next-line: missing-fields
                {
                    settings = {
                        redhat = { telemetry = { enabled = false } },
                    }
                })
            )

            local lspconfig = {
                ["angularls"] = vim.fn.executable("ngserver") == 1,
                ["bashls"] = vim.fn.executable("bash-language-server") == 1,
                ["buf_ls"] = vim.fn.executable("buf") == 1,
                ["dockerls"] = vim.fn.executable("docker-langserver") == 1,
                ["clangd"] = vim.fn.executable("clangd") == 1,
                ["cssls"] = vim.fn.executable("vscode-css-language-server") == 1,
                ["emmylua_ls"] = vim.fn.executable("emmylua_ls") == 1,
                ["glsl_analyzer"] = vim.fn.executable("glsl_analyzer") == 1,
                ["gopls"] = vim.fn.executable("gopls") == 1,
                ["gradle_ls"] = vim.fn.executable("gradle-language-server") == 1,
                ["helm_ls"] = vim.fn.executable("helm_ls") == 1,
                ["html"] = vim.fn.executable("vscode-html-language-server") == 1,
                ["hyprls"] = vim.fn.executable("hyprls") == 1,
                ["jsonls"] = vim.fn.executable("vscode-json-language-server") == 1,
                ["lemminx"] = vim.fn.executable("lemminx") == 1,
                -- ["lua_ls"] = vim.fn.executable("lua-language-server") == 1,
                ["mesonlsp"] = vim.fn.executable("mesonlsp") == 1,
                ["neocmake"] = vim.fn.executable("neocmakelsp") == 1,
                ["qmlls"] = vim.fn.executable("qmlls") == 1,
                ["rust_analyzer"] = vim.fn.executable("rust-analyzer") == 1,
                ["somesass_ls"] = vim.fn.executable("some-sass-language-server") == 1,
                ["tailwindcss"] = vim.fn.executable("tailwindcss-language-server") == 1,
                ["ts_ls"] = vim.fn.executable("typescript-language-server") == 1,
                ["yamlls"] = vim.fn.executable("yaml-language-server") == 1,
                ["zls"] = vim.fn.executable("zls") == 1,
            }

            ---@type string[]
            local enabledServers = {}

            for lspName, enabled in pairs(lspconfig) do
                if enabled then
                    table.insert(enabledServers, lspName)
                end
            end

            vim.lsp.enable(enabledServers)
        end
    }
}
