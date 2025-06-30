return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        local catppuccin = require("catppuccin")
        local colors = require("catppuccin.palettes").get_palette("mocha")

        catppuccin.setup({
            flavour = "mocha",
            no_italic = true,
            integrations = {
                lsp_trouble = false,
                blink_cmp = true,
                nvimtree = true,
                neotest = true,
                diffview = false,
                harpoon = false,
                treesitter_context = true,
                snacks = {
                    enabled = true,
                    indent_scope_color = "overlay1",
                },
            },
        })

        vim.cmd.colorscheme("catppuccin")

        vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.mantle, fg = colors.mantle })
        vim.api.nvim_set_hl(0, "WinSeparator", { bg = colors.mantle, fg = colors.mantle })
        vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = colors.mantle, fg = colors.mantle })
        vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = colors.surface1 })

        vim.api.nvim_set_hl(0, "DapUINormal", { bg = colors.mantle })
        vim.api.nvim_set_hl(0, "DapUIWinBar", { bg = colors.mantle })

        vim.api.nvim_set_hl(0, "NeotestNormal", { bg = colors.mantle })

        vim.api.nvim_create_autocmd("BufWinEnter", {
            callback = function(opts)
                if vim.bo[opts.buf].filetype == "neotest-summary" then
                    for _, v in ipairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_buf(v) == opts.buf then
                            vim.api.nvim_win_call(v, function()
                                vim.opt.winhighlight:append({ Normal = "NeotestNormal" })
                            end)
                        end
                    end
                elseif vim.bo[opts.buf].filetype == "dapui_console" then
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
