local M = {}

--- Check if a list contains a specific value or buffer object
---@param list table
---@param item any
---@return boolean, number|nil (is_present, index)
function M.contains(list, item)
  if not list then
    return false, nil
  end
  for index, v in ipairs(list) do
    if v == item then
      return true, index
    elseif type(v) == "table" and type(item) == "number" and v.id == item then
      return true, index
    elseif type(v) == "table" and type(item) == "table" and v.id == item.id then
      return true, index
    end
  end
  return false, nil
end

return M
