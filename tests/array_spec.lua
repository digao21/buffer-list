local array = require("buffer-list.util.array")

describe("Array Util Module", function()
  it("should return false and nil for empty or nil list", function()
    local is_present, index = array.contains(nil, 1)
    assert.is_false(is_present)
    assert.is_nil(index)

    is_present, index = array.contains({}, 1)
    assert.is_false(is_present)
    assert.is_nil(index)
  end)

  it("should find primitive elements in a list", function()
    local list = { "apple", "banana", "cherry" }
    local is_present, index = array.contains(list, "banana")
    assert.is_true(is_present)
    assert.are.equal(index, 2)

    is_present, index = array.contains(list, "dragonfruit")
    assert.is_false(is_present)
    assert.is_nil(index)
  end)

  it("should find buffer objects by numeric ID", function()
    local list = {
      { id = 10, path = "/foo.lua" },
      { id = 20, path = "/bar.lua" },
    }
    local is_present, index = array.contains(list, 20)
    assert.is_true(is_present)
    assert.are.equal(index, 2)

    is_present, index = array.contains(list, 30)
    assert.is_false(is_present)
    assert.is_nil(index)
  end)

  it("should find buffer objects by buffer table matching ID", function()
    local list = {
      { id = 10, path = "/foo.lua" },
      { id = 20, path = "/bar.lua" },
    }
    local is_present, index = array.contains(list, { id = 10, path = "/foo.lua" })
    assert.is_true(is_present)
    assert.are.equal(index, 1)

    is_present, index = array.contains(list, { id = 99, path = "/baz.lua" })
    assert.is_false(is_present)
    assert.is_nil(index)
  end)
end)
