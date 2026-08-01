local infra = require("buffer-list.infrastructure")
local buffer = require("buffer-list.buffer")

local name_parser = require("buffer-list.ui.name-parser")
local tabline = require("buffer-list.ui.tabline")

local M = {}

M.generateTabline = function()
  local buffers = buffer.getBuffers()

  for _, buff in ipairs(buffers) do
    buff.path = infra.splitPath(buff.path)
  end

  buffers = name_parser.parseBuffers(buffers)
  local active_id = buffer.getActive()
  return tabline.generateTabline(active_id or 0, buffers)
end

return M
