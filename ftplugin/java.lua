local jdtls = require("jdtls")
local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.expand("$HOME/.jdtls/") .. project_name

local bundles = vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar", false, true)

vim.list_extend(bundles, vim.fn.glob("$MASON/share/java-test/*.jar", false, true))
vim.list_extend(bundles, require("spring_boot").java_extensions())

vim.keymap.set("n", "<leader>rj", jdtls.pick_test, { desc = "Pick java test to run" })

---@type vim.lsp.ClientConfig
local config = {
    cmd = { "jdtls", "--jvm-arg=-javaagent:" .. lombok_jar, "-data", workspace_dir },
    cmd_env = {
        JAVA_HOME = vim.fn.expand("$HOME/.local/share/mise/installs/java/corretto-21/"),
    },
    root_dir = vim.fs.dirname(
        vim.fs.find({ "gradlew", ".git", "mvnw", "settings.gradle", "pom.xml" }, { upward = true })[1]
    ),
    init_options = {
        bundles = bundles,
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
    },
    settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            signatureHelp = {
                enabled = true,
            },
            contentProvider = {
                preferred = "fernflower",
            },
            settings = {
                url = vim.fn.stdpath("config") .. "/jdtls.properties",
            },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = vim.fn.expand("$HOME/.local/share/mise/installs/java/corretto-21/"),
                    },
                    {
                        name = "JavaSE-17",
                        path = vim.fn.expand("$HOME/.local/share/mise/installs/java/corretto-17/"),
                    },
                    {
                        name = "JavaSE-1.8",
                        path = vim.fn.expand("$HOME/.local/share/mise/installs/java/corretto-8/"),
                    },
                },
            },
        },
    },
}

jdtls.start_or_attach(config)
