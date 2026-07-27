local buffer = require("buffer-list.buffer")
local render = require("buffer-list.render")

describe("Render Module", function()
  before_each(function()
    buffer.clear()
  end)

  it("should generate tabline for empty buffer list", function()
    assert.are.equal(render.generateTabline(), "%#MyTabFill#")
  end)

  it("should generate tabline with single buffer filename and 3 spaces padding", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    assert.are.equal(render.generateTabline(), "%#MyTabInactive#   awesome.lua   %#MyTabFill#")
  end)

  it("should generate tabline for multiple buffers", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    buffer.add(2, "/home/user/project/test.lua")
    local expected = "%#MyTabInactive#   awesome.lua   %#MyTabInactive#   test.lua   %#MyTabFill#"
    assert.are.equal(render.generateTabline(), expected)
  end)

  it("should handle empty or unnamed buffers gracefully", function()
    buffer.add(1, "")
    assert.are.equal(render.generateTabline(), "%#MyTabInactive#   [No Name]   %#MyTabFill#")
  end)

  it("should use %#MyTabActive# highlight for the active buffer", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    buffer.add(2, "/home/user/project/test.lua")
    buffer.setActive(2)

    local expected = "%#MyTabInactive#   awesome.lua   %#MyTabActive#   test.lua   %#MyTabFill#"
    assert.are.equal(render.generateTabline(), expected)
  end)
end)
