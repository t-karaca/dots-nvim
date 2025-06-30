return {
    { "mfussenegger/nvim-jdtls" },
    {
        "iamkarasik/sonarqube.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("sonarqube").setup({
                lsp = {
                    cmd = {
                        "sonarlint-language-server",
                        "-stdio",
                        "-analyzers",
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjavasymbolicexecution.jar"),
                    },
                },
                rules = { enabled = true },
                csharp = {
                    enabled = false,
                },
                go = {
                    enabled = false,
                },
                html = {
                    enabled = false,
                },
                iac = {
                    -- Docker analysis only works on 'Dockerfile'
                    -- All supported files: https://github.com/SonarSource/sonar-iac
                    enabled = false,
                },
                java = {
                    enabled = true,
                    await_jdtls = true,
                },
                javascript = {
                    enabled = false,
                    clientNodePath = vim.fn.exepath("node"),
                },
                php = {
                    enabled = false,
                },
                python = {
                    enabled = false,
                },
                text = {
                    enabled = false,
                },
                xml = {
                    enabled = false,
                },
            })
        end,
    },
    {
        "JavaHello/spring-boot.nvim",
        lazy = true,
        dependencies = {
            "mfussenegger/nvim-jdtls",
        },
        config = function()
            require("spring_boot").setup({})
        end,
    }
}
