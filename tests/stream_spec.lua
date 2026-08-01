local Stream = require("buffer-list.util.stream")

describe("Stream Util Module", function()
  it("should create a stream from an array or default to empty array when nil", function()
    local s1 = Stream:new({ 1, 2, 3 })
    assert.are.same(s1:toArray(), { 1, 2, 3 })

    local s2 = Stream:new(nil)
    assert.are.same(s2:toArray(), {})

    local s3 = Stream:new()
    assert.are.same(s3:toArray(), {})
  end)

  it("should return a new array copy on toArray", function()
    local original = { 10, 20 }
    local s = Stream:new(original)
    local arr = s:toArray()

    assert.are.same(arr, { 10, 20 })
    table.insert(arr, 30)
    assert.are.same(s:toArray(), { 10, 20 })
  end)

  it("should map elements using a map function", function()
    local s = Stream:new({ 1, 2, 3 })
    local mapped = s:map(function(x)
      return x * 2
    end)

    assert.are.same(mapped:toArray(), { 2, 4, 6 })
    assert.are.same(s:toArray(), { 1, 2, 3 })
  end)

  it("should support chaining multiple map operations", function()
    local result = Stream:new({ 1, 2, 3, 4 })
      :map(function(x)
        return x * 10
      end)
      :map(function(x)
        return tostring(x)
      end)
      :toArray()

    assert.are.same(result, { "10", "20", "30", "40" })
  end)

  it("should handle map on empty streams gracefully", function()
    local result = Stream:new({})
      :map(function(x)
        return x + 1
      end)
      :toArray()

    assert.are.same(result, {})
  end)
end)
