local infrastructure = require("buffer-list.infrastructure")
local buffer = require("buffer-list.buffer")

local M = {}

--- Event handler when a buffer is added or created
---@param ev table|nil Autocommand payload containing `buf`
function M.onBufAdd(ev)
  local buf_nr = ev and ev.buf
  if not buf_nr then
    return
  end

  if infrastructure.isValid(buf_nr) and infrastructure.isBuflisted(buf_nr) then
    local path = infrastructure.getBufPath(buf_nr)
    buffer.add(buf_nr, path)
  end
end

--- Event handler when a buffer is deleted or wiped out
---@param ev table|nil Autocommand payload containing `buf`
function M.onBufDelete(ev)
  local buf_nr = ev and ev.buf
  if not buf_nr then
    return
  end

  buffer.remove(buf_nr)
end

--- Event handler when a buffer is entered
---@param ev table|nil Autocommand payload containing `buf`
function M.onBufEnter(ev)
  local buf_nr = ev and ev.buf
  if not buf_nr then
    return
  end

  if infrastructure.isValid(buf_nr) and infrastructure.isBuflisted(buf_nr) then
    local win_id = infrastructure.getCurrentWin()
    buffer.setActive(buf_nr, win_id)
  end
end

--- Handler for move-right command
function M.moveRight()
  local target_buf = buffer.getAdjacentBuffer(1)
  if target_buf then
    local win_id = buffer.getWindow(target_buf)
    infrastructure.openBuffer(target_buf, win_id)
  end
end

--- Handler for move-left command
function M.moveLeft()
  local target_buf = buffer.getAdjacentBuffer(-1)
  if target_buf then
    local win_id = buffer.getWindow(target_buf)
    infrastructure.openBuffer(target_buf, win_id)
  end
end

--- Handler for swap-right command
function M.swapRight()
  if buffer.swapBuffer(1) then
    infrastructure.redraw()
  end
end

--- Handler for swap-left command
function M.swapLeft()
  if buffer.swapBuffer(-1) then
    infrastructure.redraw()
  end
end

--- Handler for delete command
function M.delete()
  local buffers = buffer.getBuffers()
  if #buffers <= 1 then
    return
  end

  local active_buf = buffer.getActive()
  if not active_buf then
    return
  end

  local target_buf = buffer.getAdjacentBuffer(-1) or buffer.getAdjacentBuffer(1)
  local target_win = target_buf and buffer.getWindow(target_buf)

  if target_buf then
    infrastructure.openBuffer(target_buf, target_win)
  end
  infrastructure.deleteBuffer(active_buf)
end

return M
