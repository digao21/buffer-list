local infra = require("buffer-list.infrastructure")
local buffer = require("buffer-list.buffer")
local Stream = require("buffer-list.util.stream")

local name_parser = require("buffer-list.ui.name-parser")
local tabline = require("buffer-list.ui.tabline")

local M = {}

--- @param buff { id: number, path: string }
--- @return { id: number, path: string[] }
local function splitBufferPath(buff)
  return {
    id = buff.id,
    path = infra.splitPath(buff.path),
  }
end

M.generateTabline = function()
  local buffers = Stream:new(buffer.getBuffers()):map(splitBufferPath):mapAll(name_parser.parseBuffers):toArray()

  local active_id = buffer.getActive()
  local max_width = infra.getColumns()
  return tabline.generateTabline(active_id or 0, buffers, max_width)
end

return M
