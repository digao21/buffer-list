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
end)
