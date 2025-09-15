---@module "lazy"
---@type LazyPluginSpec
return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        options = {
            globalstatus = true,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch" },
            lualine_c = { { "filename", path = 1 } },
            lualine_x = {
                {
                    function()
                        return require("schema-companion").get_current_schemas()
                    end,
                    cond = function()
                        return package.loaded["schema-companion"] and
                            require("schema-companion").get_current_schemas() ~= nil
                    end,
                },
                {
                    function()
                        if not require("dap").session().stopped_thread_id then
                            return "Running"
                        end

                        return "Halted"
                    end,
                    color = function()
                        if package.loaded["dap"] then
                            local session = require("dap").session()

                            if session and session.stopped_thread_id then
                                return "DapStopped"
                            end
                        end

                        return "DapRunning"
                    end,
                    icon = "󰃤",
                    cond = function()
                        return package.loaded["dap"] and require("dap").session() ~= nil
                    end,
                },
                "encoding",
                "fileformat",
                "filetype",
            },
            lualine_y = { "lsp_status" },
            lualine_z = { "location" },
        },
        extensions = {
            "nvim-tree",
            "nvim-dap-ui",
            "mason",
            "lazy",
            "quickfix",
        },
    }
}
