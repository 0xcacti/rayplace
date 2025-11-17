local M = {}

function M.grid()
    local buf = vim.api.nvim_create_buf(false, true)
    local ui = vim.api.nvim_list_uis()[1] or { width = 80, height = 24 }
    local w, h = 2, 1

    local opts = {
        relative = "editor",
        width = w,
        height = h,
        row = math.floor((ui.height - h) / 2),
        col = math.floor((ui.width - w) / 2),
        style = "minimal",
        border = "none",
        focusable = false,
        zindex = 200,
    }
    local opts2 = {
        relative = "editor",
        width = w,
        height = h,
        row = math.floor((ui.height - h) / 2) + 1,
        col = math.floor((ui.width - w) / 2),
        style = "minimal",
        border = "none",
        focusable = false,
        zindex = 200,
    }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "■■" })
    local win = vim.api.nvim_open_win(buf, false, opts)
    local win2 = vim.api.nvim_open_win(buf, false, opts2)
    vim.api.nvim_set_hl(0, "GridNormal", { bg = "#1f2335" })
    -- vim.api.nvim_set_hl(0, "GridBorder", { bg = "#7aa2f7" })
    vim.api.nvim_win_set_option(win, "winhl", "NormalFloat:GridNormal")
    vim.api.nvim_win_set_option(win2, "winhl", "NormalFloat:GridNormal")
end

function M.setup()
    vim.api.nvim_create_user_command("Grid", function() M.grid() end, {})
end

return M
