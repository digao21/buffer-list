local config = require("buffer-list.config")

local PAD = string.rep(" ", 3)

local M = {}

local saved_start_idx = 1

--- Reset sliding window state
function M.resetWindow()
  saved_start_idx = 1
end

--- Format a buffer item truncated on the right when followed by hidden buffers
--- @param name string
--- @param rem number
--- @return string
local function format_right_truncated_item(name, rem)
  if rem <= 3 then
    return string.rep(".", rem)
  end

  local extra = rem - 3
  if extra <= #name then
    return name:sub(1, extra) .. "..."
  end

  local total_pad = extra - #name
  local left_pad_len = math.min(3, total_pad)
  local right_pad_len = total_pad - left_pad_len
  return string.rep(" ", left_pad_len) .. name .. string.rep(" ", right_pad_len) .. "..."
end

--- Format the last buffer item in the window when truncated to rem width
--- @param name string
--- @param rem number
--- @return string
local function format_last_item(name, rem)
  if rem <= #name then
    return name:sub(1, rem)
  end

  local extra = rem - #name
  local left_pad_table = { [0] = 0, [1] = 0, [2] = 1, [3] = 2, [4] = 2, [5] = 3, [6] = 3 }
  local right_pad_table = { [0] = 0, [1] = 1, [2] = 1, [3] = 1, [4] = 2, [5] = 2, [6] = 3 }

  local left_len = left_pad_table[math.min(6, extra)] or 3
  local right_len = right_pad_table[math.min(6, extra)] or 3

  return string.rep(" ", left_len) .. name .. string.rep(" ", right_len)
end

--- Generate the tabline string
--- @param active_id number
--- @param buffers { id: number, name: string }[]
--- @param max_width? number
--- @return string
function M.generateTabline(active_id, buffers, max_width)
  if #buffers == 0 then
    return config.hl_autofill
  end

  local total_buffers = #buffers
  local full_widths = {}
  local total_width = 0

  for i, buf in ipairs(buffers) do
    local w = #buf.name + 6
    full_widths[i] = w
    total_width = total_width + w
  end

  if not max_width or max_width <= 0 or total_width <= max_width then
    saved_start_idx = 1
    local parts = {}
    for _, buf in ipairs(buffers) do
      local hl = (buf.id == active_id) and config.hl_active_item or config.hl_inactive_item
      table.insert(parts, hl .. PAD .. buf.name .. PAD)
    end
    table.insert(parts, config.hl_autofill)
    return table.concat(parts, "")
  end

  local active_index = 1
  for i, buf in ipairs(buffers) do
    if buf.id == active_id then
      active_index = i
      break
    end
  end

  if saved_start_idx > total_buffers then
    saved_start_idx = total_buffers
  end
  if saved_start_idx < 1 then
    saved_start_idx = 1
  end

  if active_index < saved_start_idx then
    saved_start_idx = active_index
  end

  local start_idx = saved_start_idx
  local parts = {}
  local rem_width = max_width

  for i = start_idx, total_buffers do
    if rem_width <= 0 then
      break
    end

    local buf = buffers[i]
    local hl = (buf.id == active_id) and config.hl_active_item or config.hl_inactive_item
    local full_w = full_widths[i]

    if rem_width >= full_w then
      if i > start_idx and i < total_buffers and (rem_width - full_w < 4) then
        local item_str = format_right_truncated_item(buf.name, rem_width)
        table.insert(parts, hl .. item_str)
        break
      else
        table.insert(parts, hl .. PAD .. buf.name .. PAD)
        rem_width = rem_width - full_w
      end
    else
      local item_str
      if i < total_buffers then
        item_str = format_right_truncated_item(buf.name, rem_width)
      else
        item_str = format_last_item(buf.name, rem_width)
      end
      table.insert(parts, hl .. item_str)
      break
    end
  end

  table.insert(parts, config.hl_autofill)
  return table.concat(parts, "")
end

return M
