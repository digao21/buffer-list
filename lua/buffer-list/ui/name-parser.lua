local config = require("buffer-list.config")

local M = {}

--- Recursively resolve filename conflict for a group of items with the same filename.
--- @param items table[] List of item tables with { filename, dirs }
--- @param depth number Current directory component index (1-based)
--- @param prefix string Accumulated directory prefix for this subgroup
local function resolveConflictGroup(items, depth, prefix)
  while true do
    local all_have_same = true
    local first_dir = nil
    for i, item in ipairs(items) do
      local d = item.dirs[depth]
      if i == 1 then
        first_dir = d
      else
        if d ~= first_dir then
          all_have_same = false
          break
        end
      end
    end

    if all_have_same and first_dir ~= nil then
      depth = depth + 1
    else
      break
    end
  end

  local subgroups = {}
  local subgroup_keys = {}
  for _, item in ipairs(items) do
    local dir_comp = item.dirs[depth]
    local key = dir_comp or "__NIL__"
    if not subgroups[key] then
      subgroups[key] = {}
      table.insert(subgroup_keys, key)
    end
    table.insert(subgroups[key], item)
  end

  for _, key in ipairs(subgroup_keys) do
    local group = subgroups[key]
    local dir_comp = (key ~= "__NIL__") and key or nil

    local new_prefix = prefix
    if dir_comp then
      if new_prefix ~= "" then
        new_prefix = new_prefix .. config.SEP .. dir_comp
      else
        new_prefix = dir_comp
      end
    end

    if #group == 1 then
      local item = group[1]
      if new_prefix ~= "" then
        item.name = new_prefix .. config.SEP .. item.filename
      else
        item.name = item.filename
      end
    else
      local can_advance = false
      for _, item in ipairs(group) do
        if item.dirs[depth + 1] ~= nil then
          can_advance = true
          break
        end
      end

      if can_advance then
        resolveConflictGroup(group, depth + 1, new_prefix)
      else
        for _, item in ipairs(group) do
          if new_prefix ~= "" then
            item.name = new_prefix .. config.SEP .. item.filename
          else
            item.name = item.filename
          end
        end
      end
    end
  end
end

--- Transform the file path into the file name, resolving name conflicts
--- @param buffers { id: number, path: string[] }[]
--- @return { id: number, name: string }[]
M.parseBuffers = function(buffers)
  local items = {}
  local name_groups = {}

  for _, buff in ipairs(buffers) do
    local file_path = buff.path
    local raw_name = file_path[#file_path]
    local filename = (raw_name and raw_name ~= "") and raw_name or "[No Name]"

    local dirs = {}
    for i = 1, #file_path - 1 do
      if file_path[i] ~= "" then
        table.insert(dirs, file_path[i])
      end
    end

    local item = {
      id = buff.id,
      path = buff.path,
      filename = filename,
      dirs = dirs,
      name = nil,
    }
    table.insert(items, item)

    if not name_groups[filename] then
      name_groups[filename] = {}
    end
    table.insert(name_groups[filename], item)
  end

  for filename, group in pairs(name_groups) do
    if #group == 1 then
      group[1].name = filename
      goto continue
    end

    if filename == "[No Name]" then
      for i, item in ipairs(group) do
        item.name = filename .. " " .. i
      end

      goto continue
    end

    resolveConflictGroup(group, 1, "")

    ::continue::
  end

  local parsed_buffers = {}
  for _, item in ipairs(items) do
    table.insert(parsed_buffers, { id = item.id, name = item.name })
  end

  return parsed_buffers
end

return M
