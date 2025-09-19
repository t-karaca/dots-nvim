local dap = require("dap")
local dap_repl = require("dap.repl")
local blink_types = require("blink.cmp.types")

local function noop() end

---@param str string
local function capitalize(str)
    return str:sub(1, 1):upper() .. str:sub(2):lower()
end

--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {}

function source.new(opts)
    local self = setmetatable({}, { __index = source })
    self.opts = opts
    return self
end

function source:enabled()
    return vim.bo.filetype == "dap-repl"
end

function source:get_trigger_characters()
    local characters = { "." }

    local session = dap.session()
    if session and session.capabilities and session.capabilities.completionTriggerCharacters then
        for _, char in ipairs(session.capabilities.completionTriggerCharacters) do
            if char ~= "." then
                table.insert(characters, char)
            end
        end
    end

    return characters
end

function source:get_completions(ctx, callback)
    local session = dap.session()
    local col = ctx.cursor[2]
    local offset = vim.startswith(ctx.line, "dap> ") and 5 or 0
    local text = ctx.line:sub(offset + 1, col)

    if vim.startswith(text, ".") then
        --- @type lsp.CompletionItem[]
        local items = {}

        for _, value in pairs(dap_repl.commands) do
            for _, item in ipairs(value) do
                if type(item) == "string" then
                    ---@type lsp.CompletionItem
                    local completionItem = {
                        label = item,
                        kind = blink_types.CompletionItemKind.Event,
                        insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
                    }

                    table.insert(items, completionItem)
                end
            end
        end

        callback({
            items = items,
            is_incomplete_backward = true,
            is_incomplete_forward = true,
        })

        return noop
    end

    if not session or not session.capabilities or not session.capabilities.supportsCompletionsRequest then
        return noop
    end

    ---@type dap.CompletionsArguments
    local args = {
        frameId = (session.current_frame or {}).id,
        text = text,
        column = col + 1 - offset
    }

    ---@param err dap.ErrorResponse?
    ---@param response dap.CompletionsResponse?
    session:request('completions', args, function(err, response)
        if err then
            vim.notify('completions request failed: ' .. err.message, vim.log.levels.WARN)
        elseif response then
            local targets = response.targets
            ---
            --- @type lsp.CompletionItem[]
            local items = {}

            for _, target in pairs(targets) do
                local type = target.type and capitalize(target.type) or "Property"

                ---@type lsp.CompletionItem
                local item = {
                    insertText = target.text,
                    label = target.label,
                    detail = target.detail,
                    kind = blink_types.CompletionItemKind[type],
                    insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
                    sortText = target.sortText,
                }

                table.insert(items, item)
            end

            callback({
                items = items,
                is_incomplete_backward = true,
                is_incomplete_forward = true,
            })
        end
    end)

    return noop
end

return source
