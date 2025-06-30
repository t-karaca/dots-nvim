return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local lualine = require("lualine")
        local theme = require("lualine.themes.catppuccin-mocha")

        lualine.setup({
            options = {
                globalstatus = true,
                theme = theme,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = {
                    {
                        function()
                            return ("%s"):format(require("schema-companion.context").get_buffer_schema().name)
                        end,
                        cond = function()
                            return require("schema-companion.context").get_buffer_schema().name ~= "none"
                        end,
                    },
                    {
                        function()
                            return " "
                        end,
                        cond = function()
                            return require("dap").session() ~= nil
                        end
                    },
                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            extensions = {
                "nvim-tree",
                "nvim-dap-ui",
                "mason",
                "lazy",
                "quickfix",
            },
        })
    end,
}
