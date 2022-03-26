local M = {}

local Path = require('plenary.path')

-- Use a function to always get a new table, even if some deep field is modified,
-- like `config.commands.save = ...`. Returning a "constant" still seems to allow
-- the LSP completion to work.
local function defaults()
    -- stylua: ignore
    return {
        session_dir = (Path:new(vim.fn.stdpath('data')) / 'possession'):absolute(),
        silent = false,
        commands = {
            save = 'PossessionSave',
            load = 'PossessionLoad',
            delete = 'PossessionDelete',
            list = 'PossessionList',
        },
        close_floating_windows = true,
        hooks = {
            before_save = function(name) return {} end,
            after_save = function(name, user_data, aborted) end,
            before_load = function(name, user_data) return user_data end,
            after_load = function(name, user_data) end,
        },
        plugins = {
            nvim_tree = false,
        },
    }
end
local config = defaults()

function M.setup(opts)
    local new_config = vim.tbl_deep_extend('force', {}, defaults(), opts or {})
    -- Do _not_ replace the table pointer with `config = ...` because this
    -- wouldn't change the tables that have already been `require`d by other
    -- modules. Instead, clear all the table keys and then re-add them.
    for _, key in ipairs(vim.tbl_keys(config)) do
        config[key] = nil
    end
    for key, val in pairs(new_config) do
        config[key] = val
    end
end

-- Return the config table (getting completion!) but fall back to module methods.
return setmetatable(config, { __index = M })