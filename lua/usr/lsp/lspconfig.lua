return {
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
        "neovim/nvim-lspconfig",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "b0o/schemastore.nvim",
            "williamboman/mason.nvim",
        },
        config = function()
            local schemastore = require("schemastore")

            vim.lsp.config("clangd", {
                cmd = { "clangd", "--clang-tidy" }
            })

            vim.lsp.config("angularls", {
                root_markers = { "angular.json", "nx.json", "package.json", ".git" }
            })

            vim.lsp.config("jsonls", {
                settings = {
                    json = {
                        schemas = schemastore.json.schemas(),
                        validate = { enable = true },
                    },
                },
            })

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
