local config = require("chaplet.config")
local M = {}

M.state = nil


function M.setup(opts)
    config.setup(opts)

    vim.api.nvim_create_user_command('Chaplet', function(args)
        M.start_chaplet(args.args)
    end, {
        nargs = '?',
        complete = function()
            return { 'rosary', 'divine_mercy', 'st_michael' }
        end
    })
end

return M
