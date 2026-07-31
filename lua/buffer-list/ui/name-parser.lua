local M = {}

--- Transform the file path into the file name
--- @param buffers { id: number, path: string }[]
--- @param splitPath fun(path: string): string[]
--- @return { id: number, name: string }[]
M.parseBuffers = function(buffers, splitPath)
  local parsed_buffers = {}

  for _, buff in ipairs(buffers) do
    local file_path = splitPath(buff.path)
    local name = file_path[#file_path]
    table.insert(parsed_buffers, { id = buff.id, name = (name ~= "" and name or "[No Name]") })
  end

  return parsed_buffers
end

return M
