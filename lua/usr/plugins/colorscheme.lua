---@module "lazy"
---@type LazyPluginSpec
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        local catppuccin = require("catppuccin")

        catppuccin.setup({
            flavour = "mocha",
            no_italic = true,
            integrations = {
                blink_cmp = {
                    style = "solid",
                },
                nvimtree = true,
                dap = true,
                dap_ui = true,
                diffview = true,
                fidget = true,
                flash = true,
                treesitter_context = true,
                mason = true,
                which_key = true,
                snacks = {
                    enabled = true,
                    indent_scope_color = "overlay1",
                },
            },
            float = {
                solid = true,
                transparent = false,
            },
            custom_highlights = function(C)
                local O = catppuccin.options
                return {
                    BlinkCmpMenu = { bg = C.crust },
                    BlinkCmpMenuBorder = { bg = C.crust },
                    BlinkCmpDoc = { bg = C.crust },
                    BlinkCmpDocBorder = { bg = C.crust },
                    WinSeparator = { bg = C.mantle, fg = C.mantle },
                    NvimTreeWinSeparator = { bg = C.mantle, fg = C.mantle },
                    NvimTreeIndentMarker = { fg = C.surface1 },
                    DapRunning = { fg = C.green },
                    DapBreakpointLine = { bg = "#4d2c35" },
                    DapUINormal = { bg = C.mantle },
                    DapUIWinBar = { bg = C.mantle },
                    NvimDapViewNormal = { bg = C.mantle },
                    NvimDapViewWinBar = { bg = C.mantle },
                    ["@variable.member"] = { fg = C.lavender },
                    ["@variable.parameter.bash"] = { fg = C.maroon },
                    ["@lsp.type.interface"] = { fg = C.flamingo },
                    ["@lsp.typemod.annotation.public.java"] = { link = "@attribute.java" },
                    ["@lsp.type.namespace.java"] = { link = "@text" },
                    ["@lsp.typemod.namespace.importDeclaration.java"] = { link = "@lsp.type.namespace.java" },
                    ["@property"] = { fg = C.lavender },
                    ["@property.yaml"] = { fg = C.blue },
                    ["@property.json"] = { fg = C.blue },
                    ["@property.toml"] = { fg = C.blue },
                    ["@property.css"] = { fg = C.lavender },
                    ["@property.id.css"] = { fg = C.blue },
                    ["@tag"] = { fg = C.mauve },
                    ["@tag.attribute"] = { fg = C.teal },
                    ["@tag.delimiter"] = { fg = C.sky },
                    ["@type.tag.css"] = { fg = C.mauve },
                    ["@string.plain.css"] = { fg = C.peach },
                    ["@comment.warning"] = { link = "@comment" },
                    ["@comment.hint"] = { link = "@comment" },
                    ["@comment.note"] = { link = "@comment" },
                    ["@comment.todo"] = { link = "@comment" },
                    ["@comment.error"] = { link = "@comment" },
                }
            end,
        })

        vim.cmd.colorscheme("catppuccin")

        vim.api.nvim_create_autocmd("BufWinEnter", {
            callback = function(opts)
                if vim.bo[opts.buf].filetype == "dapui_console" then
                    for _, v in ipairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_buf(v) == opts.buf then
                            vim.api.nvim_win_call(v, function()
                                vim.opt.winhighlight:append({ WinBar = "DapUIWinBar" })
                            end)
                        end
                    end
                end
            end
        })
    end,
}
