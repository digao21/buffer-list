local config = require("buffer-list.config")

local PAD = string.rep(" ", 3)

local M = {}

--- Generate the tabline string
--- @param active_id number
--- @param buffers { id: number, name: string }[]
---@return string
function M.generateTabline(active_id, buffers)
  local parts = {}

  for _, buf in ipairs(buffers) do
    local hl = (buf.id == active_id) and config.hl_active_item or config.hl_inactive_item
    table.insert(parts, hl .. PAD .. buf.name .. PAD)
  end

  table.insert(parts, config.hl_autofill)
  return table.concat(parts, "")
end

return M
