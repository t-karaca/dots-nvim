---@module "lazy"
---@type LazyPluginSpec[]
return {
    {
        "echasnovski/mini.ai",
        version = false,
        config = function()
            require("mini.ai").setup({})
        end,
    },
    {
        "echasnovski/mini.pairs",
        version = false,
        opts = {},
    },
    {
        "echasnovski/mini.surround",
        version = false,
        config = function()
            require("mini.surround").setup({
                custom_surroundings = {
                    ["("] = { output = { left = "(", right = ")" } },
                    [")"] = { output = { left = "( ", right = " )" } },
                    ["["] = { output = { left = "[", right = "]" } },
                    ["]"] = { output = { left = "[ ", right = " ]" } },
                    ["{"] = { output = { left = "{", right = "}" } },
                    ["}"] = { output = { left = "{ ", right = " }" } },
                    ["<"] = { output = { left = "<", right = ">" } },
                    [">"] = { output = { left = "< ", right = " >" } },
                },
                mappings = {
                    add = "S",
                    delete = "<leader>S",
                    find = "",
                    find_left = "",
                    highlight = "",
                    replace = "",
                    update_n_lines = "",
                    suffix_last = "",
                    suffix_next = "",
                },
            })
        end,
    }
}
