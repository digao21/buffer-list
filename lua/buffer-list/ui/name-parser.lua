local SEP = package.config:sub(1, 1)

local M = {}

--- Transform the file path into the file name, resolving name conflicts
--- @param buffers { id: number, path: string }[]
--- @param splitPath fun(path: string): string[]
--- @return { id: number, name: string }[]
M.parseBuffers = function(buffers, splitPath)
  local items = {}
  local name_groups = {}

  for _, buff in ipairs(buffers) do
    local file_path = splitPath(buff.path or "")
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
    if #group == 1 or filename == "[No Name]" then
      for _, item in ipairs(group) do
        item.name = filename
      end
    else
      local unresolved = {}
      local max_dirs = 0

      for _, item in ipairs(group) do
        table.insert(unresolved, item)
        if #item.dirs > max_dirs then
          max_dirs = #item.dirs
        end
      end

      for depth = 1, max_dirs do
        if #unresolved == 0 then
          break
        end

        local counts = {}
        for _, item in ipairs(unresolved) do
          local dir_comp = item.dirs[depth]
          if dir_comp then
            local cand = dir_comp .. SEP .. filename
            counts[cand] = (counts[cand] or 0) + 1
          end
        end

        local next_unresolved = {}
        for _, item in ipairs(unresolved) do
          local dir_comp = item.dirs[depth]
          local cand = dir_comp and (dir_comp .. SEP .. filename) or nil
          if cand and counts[cand] == 1 then
            item.name = cand
          else
            table.insert(next_unresolved, item)
          end
        end
        unresolved = next_unresolved
      end

      for _, item in ipairs(unresolved) do
        local fallback_dir = #item.dirs > 0 and item.dirs[#item.dirs] or nil
        if fallback_dir then
          item.name = fallback_dir .. SEP .. filename
        else
          item.name = filename
        end
      end
    end
  end

  local parsed_buffers = {}
  for _, item in ipairs(items) do
    table.insert(parsed_buffers, { id = item.id, name = item.name })
  end

  return parsed_buffers
end

return M
