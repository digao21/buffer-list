local M = {}

--- Transform the file path into the file name
--- @param buffers { id: number, path: string }[]
--- @param nameTranslator fun(path: string): string
--- @return { id: number, name: string }[]
M.parseBuffers = function(buffers, nameTranslator)
  local parsed_buffers = {}

  for _, buff in ipairs(buffers) do
    table.insert(parsed_buffers, { id = buff.id, name = nameTranslator(buff.path) })
  end

  return parsed_buffers
end

return M
