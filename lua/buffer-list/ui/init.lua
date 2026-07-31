local tabline = require("buffer-list.ui.tabline")
local infra = require("buffer-list.infrastructure")
local buffer = require("buffer-list.buffer")

local function parseBuffers(buffers)
  local parsed_buffers = {}

  for _, buff in ipairs(buffers) do
    table.insert(parsed_buffers, { id = buff.id, name = infra.getFilename(buff.path) })
  end

  return parsed_buffers
end

local M = {}

M.generateTabline = function()
  local buffers = parseBuffers(buffer.getBuffers())
  local active_id = buffer.getActive()
  return tabline.generateTabline(active_id or 0, buffers)
end

return M
