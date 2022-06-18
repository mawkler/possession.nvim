local M = {}

function M.before_load(_, _, plugin_data)
    -- Deleting the current buffer before deleting other buffers will cause autocmd "BufEnter" to be triggered.
    -- Lspconfig will use the invalid buffer handler in vim.schedule.
    -- So make sure the current buffer is the last loaded one to delete.
    local current_buffer = vim.api.nvim_get_current_buf()
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buffer) and current_buffer ~= buffer then
            vim.api.nvim_buf_delete(buffer, { force = true })
        end
    end
    vim.api.nvim_buf_delete(current_buffer, { force = true })
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    return plugin_data
end

return M