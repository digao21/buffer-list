local buffer = require("buffer-list.buffer")
local infra = require("buffer-list.infrastructure")

local PAD = string.rep(" ", 3)

local M = {}

local has_initialize
--- Ensure default highlights exist
local function setupHighlights()
  infra.createHighligh("MyTabInactive", { link = "TabLineFill", default = true })
  infra.createHighligh("MyTabActive", { link = "TabLineSel", default = true })
  infra.createHighligh("MyTabFill", { bg = "NONE", default = true })
  has_initialize = true
end

--- Generate the tabline string
---@return string
function M.generateTabline()
  if not has_initialize then
    setupHighlights()
  end

  local buffers = buffer.getBuffers()
  local active_id = buffer.getActive()
  local parts = {}

  for _, buf in ipairs(buffers) do
    local filename = infra.getFilename(buf.path)
    local hl = (buf.id == active_id) and "%#MyTabActive#" or "%#MyTabInactive#"
    table.insert(parts, hl .. PAD .. filename .. PAD)
  end

  table.insert(parts, "%#MyTabFill#")
  return table.concat(parts, "")
end

return M
