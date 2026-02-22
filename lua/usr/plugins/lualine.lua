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
            always_show_tabline = false,
        },
        tabline = {
            lualine_a = {
                {
                    "tabs",
                    mode = 1,
                    path = 0,
                    show_modified_status = false,
                }
            }
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
                {
                    function()
                        return "Running " .. require("usr.taskfile").current_task
                    end,
                    icon = { "", color = { fg = "green" } },
                    cond = function()
                        return require("usr.taskfile").is_task_running()
                    end
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
    },
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "checkhealth",
            callback = function()
                vim.api.nvim_tabpage_set_var(0, "tabname", "Checkhealth")
            end
        })
    end,
}
