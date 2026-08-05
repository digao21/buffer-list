local config = require("buffer-list.config")

local PAD = string.rep(" ", 3)

local M = {}

--- @type number
local saved_start_idx = 1

--- @type boolean
local fill_right = true

--- Reset sliding window state
function M.resetWindow()
  saved_start_idx = 1
end

local function revert(arr)
  local new_arr = {}

  for i=#arr, 1, -1 do
    table.insert(new_arr, arr[i])
  end

  return new_arr
end

--- Returns the index of the active buffer inside buffers array or nil otherwise
--- @param active_id number
--- @param buffers { id: number, name: string, lt_pad: string, rt_pad: string }[]
local function getActiveBufferIndex(active_id, buffers)
  for idx, buff in ipairs(buffers) do
    if active_id == buff.id then return idx end
  end

  return nil
end

--- @param buffer { id: number, name: string, lt_pad: string, rt_pad: string }
local function getBufferLength(buffer)
  return #(buffer.name) + #(buffer.lt_pad) + #(buffer.rt_pad)
end

local fillRight
local fillLeft

fillRight = function(active_id, buffers, max_width)
  local active_buffer_idx = getActiveBufferIndex(active_id, buffers)

  if active_buffer_idx ~= nil and active_buffer_idx < saved_start_idx then
    saved_start_idx = active_buffer_idx
  end

  local i = saved_start_idx
  local new_buffers = {}
  local tab_size = 0

  while i <= #buffers and tab_size + getBufferLength(buffers[i]) <= max_width do
    tab_size = tab_size + getBufferLength(buffers[i])
    table.insert(new_buffers, buffers[i])
    i = i+1
  end

  if i > #buffers then
    if saved_start_idx > 1 then
      new_buffers[1].lt_pad = "..."
    end

    return new_buffers
  end

  if #new_buffers == 0 then
    local idx = active_buffer_idx or (buffers[saved_start_idx] and saved_start_idx or 1)
    local new_buff = {
      id = buffers[idx].id,
      lt_pad = "",
      rt_pad = ""
    }

    if max_width <= 3 then
      new_buff.name = string.sub(buffers[idx].name, 1, max_width)
    else
      new_buff.name = string.sub(buffers[idx].name, 1, max_width-3) .. "..."
    end

    return { new_buff }
  end

  if active_buffer_idx == nil or i > active_buffer_idx then
    -- No need to slide
    -- And we have extra files to the right
    if saved_start_idx > 1 then
      new_buffers[1].lt_pad = "..."
    end

    if max_width - tab_size <= 3 then
      new_buffers[#new_buffers].rt_pad = string.rep(" ", max_width - tab_size) .. "..."
      return new_buffers
    end

    if tab_size + getBufferLength(buffers[i]) - max_width <= 3 then
      buffers[i].lt_pad = string.rep(" ", 3 - (tab_size + getBufferLength(buffers[i]) - max_width))

      if i < #buffers then
        buffers[i].rt_pad = "..."
      end

      table.insert(new_buffers, buffers[i])
      return new_buffers
    end

    local spaces_to_remove = tab_size + getBufferLength(buffers[i]) - max_width

    buffers[i].lt_pad = ""
    spaces_to_remove = spaces_to_remove - 3

    buffers[i].rt_pad = ""
    local name = buffers[i].name .. "..."

    name = string.sub(name, 1, #name - spaces_to_remove)
    name = string.sub(name, 1, #name - 3) .. "..."

    buffers[i].name = name

    table.insert(new_buffers, buffers[i])
    return new_buffers
  end

  -- Slide .:|:.
  saved_start_idx = active_buffer_idx
  fill_right = false
  return fillLeft(active_id, buffers, max_width)
end

--- Return truncated buffers ready to print
--- @param active_id number
--- @param buffers { id: number, name: string, lt_pad: string, rt_pad: string }[]
--- @param max_width number
fillLeft = function(active_id, buffers, max_width)
  local active_buffer_idx = getActiveBufferIndex(active_id, buffers)

  if active_buffer_idx ~= nil and saved_start_idx < active_buffer_idx then
    saved_start_idx = active_buffer_idx
  end

  local i = saved_start_idx
  local new_buffers = {}
  local tab_size = 0

  while 0 < i and tab_size + getBufferLength(buffers[i]) <= max_width do
    tab_size = tab_size + getBufferLength(buffers[i])
    table.insert(new_buffers, buffers[i])
    i = i-1
  end

  if i <= 0 then
    if saved_start_idx < #buffers then
      new_buffers[#new_buffers].rt_pad = "..."
    end

    return revert(new_buffers)
  end

  if #new_buffers == 0 then
    local idx = active_buffer_idx or (buffers[saved_start_idx] and saved_start_idx or 1)
    local new_buff = {
      id = buffers[idx].id,
      lt_pad = "",
      rt_pad = ""
    }

    if max_width <= 3 then
      new_buff.name = string.sub(buffers[idx].name, 1, max_width)
    else
      new_buff.name = "..." .. string.sub(buffers[idx].name, 1, max_width-3)
    end

    return { new_buff }
  end

  if active_buffer_idx == nil or i < active_buffer_idx then
    -- No need to slide
    -- And we have extra files to the left
    if saved_start_idx < #buffers then
      new_buffers[1].rt_pad = "..."
    end

    if max_width - tab_size <= 3 then
      new_buffers[#new_buffers].lt_pad = "..." .. string.rep(" ", max_width - tab_size)
      return revert(new_buffers)
    end

    if tab_size + getBufferLength(buffers[i]) - max_width <= 3 then
      buffers[i].rt_pad = string.rep(" ", 3 - (tab_size + getBufferLength(buffers[i]) - max_width))

      if 1 < i then
        buffers[i].lt_pad = "..."
      end

      table.insert(new_buffers, buffers[i])
      return revert(new_buffers)
    end

    local spaces_to_remove = tab_size + getBufferLength(buffers[i]) - max_width

    buffers[i].rt_pad = ""
    spaces_to_remove = spaces_to_remove - 3

    buffers[i].lt_pad = ""
    local name = "..." .. buffers[i].name

    name = string.sub(name, spaces_to_remove + 1)
    name = "..." .. string.sub(name, 4)

    buffers[i].name = name

    table.insert(new_buffers, buffers[i])
    return revert(new_buffers)
  end

  -- Slide .:|:.
  saved_start_idx = active_buffer_idx
  fill_right = true
  return fillRight(active_id, buffers, max_width)
end

--- Add padding to buffers
--- @param buffers { id: number, name: string }[]
--- @return { id: number, name: string, lt_pad: string, rt_pad: string }[]
local function addPad(buffers)
  local new_buffers = {}
  for _, buff in ipairs(buffers) do
    table.insert(new_buffers, {
      id = buff.id,
      name = buff.name,
      lt_pad = PAD,
      rt_pad = PAD
    })
  end

  return new_buffers
end

--- Generate the tabline string
--- @param active_id number
--- @param buffers { id: number, name: string }[]
--- @param max_width? number
--- @return string
function M.generateTabline(active_id, buffers, max_width)
  local buffers_with_pad = addPad(buffers)
  local truncated_buffers = buffers_with_pad

  if max_width ~= nil and #buffers > 0 then
    if fill_right then
      truncated_buffers = fillRight(active_id, buffers_with_pad, max_width)
    else
      truncated_buffers = fillLeft(active_id, buffers_with_pad, max_width)
    end
  end

  local tabline = {}
  for _, buff in ipairs(truncated_buffers) do
    local hl = (buff.id == active_id) and config.hl_active_item or config.hl_inactive_item

    table.insert(tabline, hl)
    table.insert(tabline, buff.lt_pad)
    table.insert(tabline, buff.name)
    table.insert(tabline, buff.rt_pad)
  end

  table.insert(tabline, config.hl_autofill)
  return table.concat(tabline, "")
end

return M
