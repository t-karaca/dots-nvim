---@module "lazy"
---@type LazyPluginSpec[]
return {
    {
        "towolf/vim-helm",
        ft = "helm",
    },
    {
        "williamboman/mason.nvim",
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
                cmd = { "clangd", "--clang-tidy" }
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

            -- local mappedSchemas = vim.tbl_map(function(schema)
            --     return {
            --         uri = schema.url,
            --         name = schema.name,
            --         description = schema.description,
            --     }
            -- end, jsonSchemas)

            vim.lsp.config("yamlls", schemaCompanion.setup_client(
                schemaCompanion.adapters.yamlls.setup({
                    sources = {
                        schemaCompanion.sources.matchers.kubernetes.setup({ version = "master" }),
                        -- schemaCompanion.sources.schemas.setup(mappedSchemas),
                        schemaCompanion.sources.lsp.setup(),
                    },
                }),
                ---@diagnostic disable-next-line: missing-fields
                {
                    settings = {
                        redhat = { telemetry = { enabled = false } },
                        yaml = {
                            -- schemaStore = {
                            --     enable = false,
                            --     url = "",
                            -- },
                            -- schemas = schemastore.yaml.schemas(),
                        },
                    }
                })
            )


            vim.lsp.enable({
                "buf_ls",
                "neocmake",
                "mesonlsp",
                "clangd",
                "lemminx",
                "gopls",
                "bashls",
                "gradle_ls",
                "dockerls",
                "zls",
                "rust_analyzer",
                "glsl_analyzer",
                "helm_ls",
                "jsonls",
                "yamlls",
                "html",
                "ts_ls",
                "cssls",
                "somesass_ls",
                "tailwindcss",
                "lua_ls",
                "angularls",
            })
        end
    }
}
