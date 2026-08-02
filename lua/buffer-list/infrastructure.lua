local config = require("buffer-list.config")

local M = {}

--- Check if a buffer handle is valid in Neovim
---@param buf_nr number
---@return boolean
function M.isValid(buf_nr)
  if not buf_nr or buf_nr <= 0 then
    return false
  end

  return vim.api.nvim_buf_is_valid(buf_nr)
end

--- Check if a buffer is listed (:ls)
---@param buf_nr number
---@return boolean
function M.isBuflisted(buf_nr)
  if not M.isValid(buf_nr) then
    return false
  end

  return vim.bo[buf_nr].buflisted
end

--- Get buffer path
---@param buf_nr number
---@return string
function M.getBufPath(buf_nr)
  if not M.isValid(buf_nr) then
    return ""
  end

  return vim.api.nvim_buf_get_name(buf_nr)
end

--- Get all listed buffers in Neovim
---@return number[]
function M.getListedBuffers()
  local all_bufs = vim.api.nvim_list_bufs()
  local listed_bufs = {}

  for _, buf_nr in ipairs(all_bufs) do
    if M.isBuflisted(buf_nr) then
      table.insert(listed_bufs, buf_nr)
    end
  end

  return listed_bufs
end

--- Get file name
--- @param path string
--- @return string
function M.getFilename(path)
  return path == "" and "[No Name]" or vim.fn.fnamemodify(path, ":t")
end

--- Creates a highlight
--- @param name string
--- @param opt table
function M.createHighligh(name, opt)
  vim.api.nvim_set_hl(0, name, opt)
end

--- Get current window ID
--- @return number
function M.getCurrentWin()
  return vim.api.nvim_get_current_win()
end

--- Check if a window handle is valid
--- @param win_id number|nil
--- @return boolean
function M.isWinValid(win_id)
  if not win_id or win_id <= 0 then
    return false
  end

  return vim.api.nvim_win_is_valid(win_id)
end

--- Switch window to the specified buffer
--- @param buf_nr number
--- @param win_id number|nil Target window ID (optional)
--- @return boolean
function M.openBuffer(buf_nr, win_id)
  if not M.isValid(buf_nr) then
    return false
  end

  local current_win = M.getCurrentWin()

  if win_id and M.isWinValid(win_id) then
    vim.api.nvim_win_set_buf(win_id, buf_nr)
    if win_id ~= current_win then
      vim.api.nvim_set_current_win(current_win)
    end
  else
    vim.api.nvim_set_current_buf(buf_nr)
  end

  return true
end

--- Delete a buffer in Neovim
--- @param buf_nr number
--- @return boolean
function M.deleteBuffer(buf_nr)
  if not M.isValid(buf_nr) then
    return false
  end

  vim.api.nvim_buf_delete(buf_nr, { force = false })
  return true
end

--- Split file pathname into an array using OS standard separator
--- @param path string
--- @return string[]
function M.splitPath(path)
  return vim.split(path, config.SEP, { plain = true })
end

--- Force Neovim to redraw tabline UI
function M.redraw()
  vim.cmd("redrawtabline")
end

--- Get total screen width in columns
--- @return number
function M.getColumns()
  return vim.o.columns
end

return M
