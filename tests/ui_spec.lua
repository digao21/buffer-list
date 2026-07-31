local buffer = require("buffer-list.buffer")
local ui = require("buffer-list.ui")

describe("UI Module", function()
  before_each(function()
    buffer.clear()
  end)

  it("should generate tabline for empty buffer list", function()
    assert.are.equal(ui.generateTabline(), "%#NONE#")
  end)

  it("should generate tabline with single buffer filename and 3 spaces padding", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    assert.are.equal(ui.generateTabline(), "%#TabLineFill#   awesome.lua   %#NONE#")
  end)

  it("should generate tabline for multiple buffers", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    buffer.add(2, "/home/user/project/test.lua")
    local expected = "%#TabLineFill#   awesome.lua   %#TabLineFill#   test.lua   %#NONE#"
    assert.are.equal(ui.generateTabline(), expected)
  end)

  it("should handle empty or unnamed buffers gracefully", function()
    buffer.add(1, "")
    assert.are.equal(ui.generateTabline(), "%#TabLineFill#   [No Name]   %#NONE#")
  end)

  it("should use %#TabLineSel# highlight for the active buffer", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    buffer.add(2, "/home/user/project/test.lua")
    buffer.setActive(2)

    local expected = "%#TabLineFill#   awesome.lua   %#TabLineSel#   test.lua   %#NONE#"
    assert.are.equal(ui.generateTabline(), expected)
  end)

  describe("Name Conflict Resolution", function()
    it("should resolve conflict using first differing directory component (Example 1)", function()
      buffer.add(1, "/home/test/project/file.lua")
      buffer.add(2, "/home/exam/project/file.lua")

      local expected = "%#TabLineFill#   test/file.lua   %#TabLineFill#   exam/file.lua   %#NONE#"
      assert.are.equal(ui.generateTabline(), expected)
    end)

    it("should resolve conflict using first differing directory component (Example 2)", function()
      buffer.add(1, "/home/agua/project/test/file.lua")
      buffer.add(2, "/home/rosa/project/exam/file.lua")

      local expected = "%#TabLineFill#   agua/file.lua   %#TabLineFill#   rosa/file.lua   %#NONE#"
      assert.are.equal(ui.generateTabline(), expected)
    end)
  end)
end)
