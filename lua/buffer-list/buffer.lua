local util = require("buffer-list.util")

local M = {}

-- List of managed buffer objects: { id = number, path = string }
local managed_buffers = {}
local active_buffer = nil

--- Get all currently managed buffers
---@return { id: number, path: string }[]
function M.getBuffers()
  local buffer_copy = {}
  for i, buf in ipairs(managed_buffers) do
    buffer_copy[i] = { id = buf.id, path = buf.path }
  end
  return buffer_copy
end

--- Get the currently active buffer ID
---@return number|nil
function M.getActive()
  return active_buffer
end

--- Set the currently active buffer
---@param buf_nr number|nil
---@param win_id number|nil
---@return boolean success
function M.setActive(buf_nr, win_id)
  if not buf_nr or buf_nr <= 0 then
    return false
  end
  active_buffer = buf_nr
  if win_id and win_id > 0 then
    M.setWindow(buf_nr, win_id)
  end
  return true
end

--- Associate a window handle with a buffer
---@param buf_nr number
---@param win_id number|nil
---@return boolean
function M.setWindow(buf_nr, win_id)
  if not buf_nr or buf_nr <= 0 then
    return false
  end
  for _, buf in ipairs(managed_buffers) do
    if buf.id == buf_nr then
      buf.win = win_id
      return true
    end
  end
  return false
end

--- Get last associated window handle for a buffer
---@param buf_nr number
---@return number|nil
function M.getWindow(buf_nr)
  if not buf_nr or buf_nr <= 0 then
    return nil
  end
  for _, buf in ipairs(managed_buffers) do
    if buf.id == buf_nr then
      return buf.win
    end
  end
  return nil
end

--- Add a buffer to the managed list if not already present
---@param buf_nr number
---@param path string|nil Full path of the buffer
---@return boolean added
function M.add(buf_nr, path)
  if not buf_nr or buf_nr <= 0 then
    return false
  end
  local is_present = util.contains(managed_buffers, buf_nr)
  if not is_present then
    table.insert(managed_buffers, { id = buf_nr, path = path or "" })
    return true
  end
  return false
end

--- Remove a buffer from the managed list
---@param buf_nr number
---@return boolean removed
function M.remove(buf_nr)
  if not buf_nr then
    return false
  end
  if active_buffer == buf_nr then
    active_buffer = nil
  end
  local is_present, index = util.contains(managed_buffers, buf_nr)
  if is_present and index then
    table.remove(managed_buffers, index)
    return true
  end
  return false
end

--- Clear all managed buffers
function M.clear()
  managed_buffers = {}
  active_buffer = nil
end

--- Get buffer ID at a relative offset from active buffer
---@param offset number
---@return number|nil
function M.getAdjacentBuffer(offset)
  if not offset or type(offset) ~= "number" or not active_buffer then
    return nil
  end

  local active_index = nil
  for i, buf in ipairs(managed_buffers) do
    if buf.id == active_buffer then
      active_index = i
      break
    end
  end

  if not active_index then
    return nil
  end

  local target_index = active_index + offset
  if target_index >= 1 and target_index <= #managed_buffers then
    return managed_buffers[target_index].id
  end

  return nil
end

--- Swap active buffer position with buffer at relative offset
---@param offset number
---@return boolean success
function M.swapBuffer(offset)
  if not offset or type(offset) ~= "number" or not active_buffer then
    return false
  end

  local active_index = nil
  for i, buf in ipairs(managed_buffers) do
    if buf.id == active_buffer then
      active_index = i
      break
    end
  end

  if not active_index then
    return false
  end

  local target_index = active_index + offset
  if target_index >= 1 and target_index <= #managed_buffers then
    managed_buffers[active_index], managed_buffers[target_index] =
      managed_buffers[target_index], managed_buffers[active_index]
    return true
  end

  return false
end

return M
