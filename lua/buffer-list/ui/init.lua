local infra = require("buffer-list.infrastructure")
local buffer = require("buffer-list.buffer")

local name_parser = require("buffer-list.ui.name-parser")
local tabline = require("buffer-list.ui.tabline")

local M = {}

M.generateTabline = function()
  local buffers = name_parser.parseBuffers(buffer.getBuffers(), infra.splitPath)
  local active_id = buffer.getActive()
  return tabline.generateTabline(active_id or 0, buffers)
end

return M
