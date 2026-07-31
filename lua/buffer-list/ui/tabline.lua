local infra = require("buffer-list.infrastructure")

local M = {}

local has_initialize
--- Ensure default highlights exist
local function setupHighlights()
  infra.createHighligh("MyTabInactive", { link = "TabLineFill", default = true })
  infra.createHighligh("MyTabActive", { link = "TabLineSel", default = true })
  infra.createHighligh("MyTabFill", { bg = "NONE", default = true })
  has_initialize = true
end

--- Setup UI highlights
function M.setup()
  if not has_initialize then
    setupHighlights()
  end
end

--- Generate the tabline string
---@return string
function M.generateTabline(active_id, buffers)
  M.setup()

  local parts = {}

  for _, buf in ipairs(buffers) do
    local hl = (buf.id == active_id) and "%#MyTabActive#" or "%#MyTabInactive#"
    table.insert(parts, hl .. PAD .. buf.name .. PAD)
  end

  table.insert(parts, "%#NONE#")
  return table.concat(parts, "")
end


return M
