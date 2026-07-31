local command = require("buffer-list.command")
local ui = require("buffer-list.ui")

local augroup_id = vim.api.nvim_create_augroup("BufferListAutoCmds", { clear = true })

vim.api.nvim_create_autocmd({ "BufAdd", "BufCreate" }, {
  group = augroup_id,
  callback = function(ev)
    command.onBufAdd(ev)
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = augroup_id,
  callback = function(ev)
    command.onBufDelete(ev)
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = augroup_id,
  callback = function(ev)
    command.onBufEnter(ev)
  end,
})

_G.BufferListTabline = ui.generateTabline
-- luacheck: push ignore 122
vim.o.tabline = "%!v:lua.BufferListTabline()"
vim.o.showtabline = 2
-- luacheck: pop

vim.api.nvim_create_user_command("BufferList", function(opts)
  local arg = opts.args
  if arg == "move-right" then
    command.moveRight()
  elseif arg == "move-left" then
    command.moveLeft()
  elseif arg == "swap-right" then
    command.swapRight()
  elseif arg == "swap-left" then
    command.swapLeft()
  elseif arg == "delete" then
    command.delete()
  end
end, {
  nargs = 1,
  complete = function(ArgLead)
    local subcommands = { "move-right", "move-left", "swap-right", "swap-left", "delete" }
    local matches = {}
    for _, subcmd in ipairs(subcommands) do
      if subcmd:sub(1, #ArgLead) == ArgLead then
        table.insert(matches, subcmd)
      end
    end
    return matches
  end,
})
