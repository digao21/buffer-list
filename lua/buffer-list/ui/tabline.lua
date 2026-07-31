local PAD = string.rep(" ", 3)

local M = {}

--- Generate the tabline string
--- @param active_id number
--- @param buffers { id: number, name: string }[]
---@return string
function M.generateTabline(active_id, buffers)
  local parts = {}

  for _, buf in ipairs(buffers) do
    local hl = (buf.id == active_id) and "%#TabLineSel#" or "%#TabLineFill#"
    table.insert(parts, hl .. PAD .. buf.name .. PAD)
  end

  table.insert(parts, "%#NONE#")
  return table.concat(parts, "")
end

return M
