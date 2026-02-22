---@class taskfile.Task
---@field name string
---@field desc string
---@field summary string

---@class taskfile.Response
---@field tasks taskfile.Task[]
---@field location string

local dap = require("dap")

local BINARY_NAME = "task"

local M = {}

M.current_task = ""
M.last_run_task = ""
M.win_id = -1
M.buf_id = -1
M.job_id = -1
M.lines = {}

---@type taskfile.Task[]
M.tasks = {}

M.fs_event = nil

---@module "snacks"
---@type snacks.win | nil
M.snacks_win = nil

function M.is_available()
    return vim.fn.executable(BINARY_NAME) == 1
end

function M.watch_start()
    if not M.fs_event then
        M.fs_event = vim.uv.new_fs_event()
    end

    -- TODO: watch for all files included in Taskfile.yaml
    M.fs_event:start("Taskfile.yaml", {}, function()
        M.load_tasks()
    end)
end

function M.watch_stop()
    if not M.fs_event then
        return
    end

    M.fs_event:stop()
end

function M.setup()
    if not M.is_available() then
        vim.notify("task binary is not available, disabling plugin", vim.log.levels.WARN)
        return
    end

    local function complete()
        return vim.tbl_map(function(task) return task.name end, M.tasks)
    end

    vim.api.nvim_create_user_command("Task", function(input)
        if not input.args or input.args == "" then
            M.select_task(input.bang)
        else
            M.run_task(input.fargs[1], { force_open = input.bang })
        end
    end, {
        complete = complete,
        nargs = "?",
        bang = true,
    })

    vim.api.nvim_create_user_command("TaskOutput", M.toggle_float, {})
    vim.api.nvim_create_user_command("TaskStop", M.stop_task, {})

    vim.keymap.set("n", "<leader>xx", M.run_last_task, { desc = "Run last executed task" })
    vim.keymap.set("n", "<leader>xs", M.select_task, { desc = "Select task to run" })
    vim.keymap.set("n", "<leader>xl", function() M.run_last_task(true) end,
        { desc = "Run last executed task and show terminal" })
    vim.keymap.set("n", "<leader>xe", function() M.select_task(true) end,
        { desc = "Select task to run and show terminal" })
    vim.keymap.set("n", "<leader>xf", M.toggle_float, { desc = "Toggle task output window" })
    -- vim.keymap.set("n", "<leader>xd", M.toggle_win, { desc = "Toggle window for task output" })
    vim.keymap.set("n", "<leader>xr", M.load_tasks, { desc = "Reload tasks from file" })

    -- vim.api.nvim_create_autocmd("BufWinEnter", {
    --     callback = function(ctx)
    --         if vim.bo.filetype == "taskfile-terminal" then
    --             vim.wo.winhl = "Normal:NormalFloat"
    --         end
    --     end
    -- })
    --
    -- vim.api.nvim_create_autocmd("BufWinLeave", {
    --     callback = function(ctx)
    --         if vim.bo.filetype == "taskfile-terminal" then
    --             vim.wo.winhl = ""
    --
    --             if M.is_task_running() then
    --                 vim.fn.jobresize(M.job_id, 999, 999)
    --             end
    --         end
    --     end
    -- })

    M.load_tasks()

    dap.listeners.on_config["taskfile"] = function(config)
        if config.beforeTask then
            local co = coroutine.running()

            M.run_task(config.beforeTask, {
                no_history = true,
                on_exit = function(code)
                    coroutine.resume(co, code == 0)
                end,
            })

            local shouldContinue = coroutine.yield()

            return shouldContinue and config or { dap.ABORT }
        end

        return config
    end
end

function M.get_buf()
    if not vim.api.nvim_buf_is_loaded(M.buf_id) then
        M.buf_id = vim.api.nvim_create_buf(false, true)

        vim.keymap.set("n", "q", ":close<CR>", { buffer = M.buf_id })

        vim.bo[M.buf_id].buflisted = false
        vim.bo[M.buf_id].filetype = "taskfile-terminal"
    end

    return M.buf_id
end

function M.is_win_open()
    return vim.api.nvim_win_is_valid(M.win_id) and vim.api.nvim_win_get_buf(M.win_id) == M.buf_id
end

function M.is_task_running()
    return M.job_id > 0
end

function M.stop_task()
    if M.is_task_running() then
        vim.notify("Stopping task '" .. M.current_task .. "'", vim.log.levels.INFO, { title = "Taskfile" })
        vim.fn.jobstop(M.job_id)
    else
        vim.notify("No task running to stop", vim.log.levels.WARN, { title = "Taskfile" })
    end
end

function M.get_snacks_win()
    if not M.snacks_win then
        M.snacks_win = Snacks.win.new({
            position = "float",
            buf = M.get_buf(),
            width = 0.9,
            height = 0.9,
            border = "solid",
            show = false,
            fixbuf = true,
            enter = true,
        })

        M.snacks_win:on("WinLeave", function(win)
            win:close()
        end)
    end

    return M.snacks_win
end

---@param force? boolean
function M.open_win(force)
    if not force and M.current_task == "" then
        vim.notify("No task has been run yet", vim.log.levels.WARN)
        return
    end

    if not vim.api.nvim_win_is_valid(M.win_id) then
        M.win_id = vim.api.nvim_open_win(M.get_buf(), false, {
            split = "right",
        })
    end

    return M.win_id
end

function M.toggle_win()
    if vim.api.nvim_win_is_valid(M.win_id) then
        vim.api.nvim_win_close(M.win_id, false)
    else
        M.open_win()
    end
end

function M.toggle_float()
    -- if M.snacks_win:valid() then
    --     M.snacks_win:close()
    -- else
    --     M.snacks_win:show()
    --     vim.api.nvim_buf_set_lines(M.snacks_win.buf, 0, vim.tbl_count(M.lines), false, M.lines)
    --     Snacks.terminal.colorize()
    -- end

    if M.current_task == "" then
        vim.notify("No task has been run yet", vim.log.levels.WARN)
        return
    end

    M.get_snacks_win():toggle()
end

---@class taskfile.RunOpts
---@field force_open? boolean
---@field on_exit? fun(code: integer)
---@field no_history? boolean

---@param name string
---@param opts? taskfile.RunOpts
function M.run_task(name, opts)
    local force_open = opts and opts.force_open or false
    local no_history = opts and opts.no_history or false

    if not name or name == "" then
        vim.notify("Task name must not be empty", vim.log.levels.ERROR)

        if opts and opts.on_exit then
            opts.on_exit(-1)
        end

        return
    end

    -- M.open_win(true)

    if M.is_task_running() then
        if opts and opts.on_exit then
            opts.on_exit(-1)
        end

        if name ~= M.current_task then
            vim.notify("There is already another task running", vim.log.levels.ERROR)

            return
        end

        M.get_snacks_win():show()
        return
    end

    M.lines = {}
    M.current_task = name

    if not no_history then
        M.last_run_task = name
    end

    M.get_snacks_win():show()

    if not force_open then
        M.get_snacks_win():close()
    end

    vim.bo[M.get_buf()].modified = false

    vim.api.nvim_buf_call(M.get_buf(), function()
        local job = vim.fn.jobstart({ BINARY_NAME, name }, {
            term = true,
            on_exit = function(id, code)
                M.job_id = -1

                if code == 0 then
                    vim.notify("'" .. name .. "' finished successfully", vim.log.levels.INFO, { title = "Taskfile" })
                else
                    vim.notify("'" .. name .. "' failed", vim.log.levels.ERROR, { title = "Taskfile" })
                end

                if not force_open and code ~= 0 then
                    M.get_snacks_win():show()
                end

                if opts and opts.on_exit then
                    opts.on_exit(code)
                end

                -- if not force_open and not M.get_snacks_win():valid() and code == 0 then
                --     vim.notify("'" .. name .. "' finished successfully", vim.log.levels.INFO, { title = "Taskfile" })
                -- else
                --     M.get_snacks_win():show()
                -- end

                -- if not M.is_win_open() then
                --     if code == 0 then
                --         vim.notify(name .. " task finished", vim.log.levels.INFO)
                --     else
                --         vim.notify(name .. " task failed", vim.log.levels.ERROR)
                --     end
                -- end
            end
        })

        if job > 0 then
            M.job_id = job
        end
    end)
end

---@param force_open? boolean
function M.run_last_task(force_open)
    if M.last_run_task ~= "" then
        M.run_task(M.last_run_task, { force_open = force_open })
    else
        M.select_task(force_open)
    end
end

---@param force_open? boolean
function M.select_task(force_open)
    if not vim.tbl_isempty(M.tasks) then
        vim.ui.select(M.tasks, {
            prompt = "Select task to run",
            ---@param task taskfile.Task
            format_item = function(task)
                return task.name
            end,
        }, function(item, idx)
            if item then
                M.run_task(item.name, { force_open = force_open })
            end
        end)
    else
        vim.notify("No tasks available", vim.log.levels.WARN)
    end
end

function M.load_tasks()
    ---@param response vim.SystemCompleted
    local function decode(response)
        if response.code ~= 0 then
            return
        end

        local stdout = response.stdout

        ---@type taskfile.Response
        local data = vim.fn.json_decode(stdout)

        if data and data.tasks then
            M.tasks = data.tasks
        end

        M.watch_stop()
        M.watch_start()
    end

    vim.system({ BINARY_NAME, "--list-all", "--json" }, {}, vim.schedule_wrap(decode))
end

return M
