---@module "lazy"
---@type LazyPluginSpec[]
return {
    { "mfussenegger/nvim-jdtls" },
    {
        "JavaHello/spring-boot.nvim",
        lazy = true,
        dependencies = {
            "mfussenegger/nvim-jdtls",
        },
        config = function()
            require("spring_boot").setup({
                java_cmd = vim.fn.expand("$HOME/.local/share/mise/installs/java/corretto-21/bin/java"),
            })
        end,
    },
    {
        "iamkarasik/sonarqube.nvim",
        lazy = true,
        ft = { "java" },
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
                    cmd_env = {
                        JAVA_HOME = vim.fn.expand("$HOME/.local/share/mise/installs/java/corretto-21/"),
                    },
                },
                rules = {
                    enabled = true,
                    ["java:S1135"] = { enabled = false }, -- Track uses of "TODO" tags
                },
                java = {
                    enabled = true,
                    await_jdtls = true,
                },
                csharp = { enabled = false },
                go = { enabled = false },
                html = { enabled = false },
                javascript = { enabled = false },
                php = { enabled = false },
                python = { enabled = false },
                text = { enabled = false },
                xml = { enabled = false },
                iac = {
                    -- Docker analysis only works on 'Dockerfile'
                    -- All supported files: https://github.com/SonarSource/sonar-iac
                    enabled = false,
                },
            })
        end,
    },
}
