local Stream = {}

Stream.__index = Stream

--- @class buffer-list.util.Stream
--- @generic T

--- Creates a new Stream
--- @generic T
--- @param arr T[]
--- @return buffer-list.util.Stream<T>
function Stream:new(arr)
  local instance = setmetatable({}, self)
  instance.arr = arr or {}

  return instance
end

--- Map elements from Stream
--- @generic T,K
--- @param mapFunc fun(item: T): K
--- @return buffer-list.util.Stream<K>
function Stream:map(mapFunc)
  local new_arr = {}

  for _, item in ipairs(self.arr) do
    table.insert(new_arr, mapFunc(item))
  end

  return Stream:new(new_arr)
end

--- Returns the content of the Stream
--- @generic T
--- @return T[]
function Stream:toArray()
  local new_arr = {}

  for _, item in ipairs(self.arr) do
    table.insert(new_arr, item)
  end

  return new_arr
end

return Stream
