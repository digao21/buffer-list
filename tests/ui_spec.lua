local buffer = require("buffer-list.buffer")
local config = require("buffer-list.config")
local ui = require("buffer-list.ui")

describe("UI Module (ui/init.lua)", function()
  before_each(function()
    buffer.clear()
  end)

  it("should generate tabline for empty buffer list", function()
    assert.are.equal(ui.generateTabline(), config.hl_autofill)
  end)

  it("should generate tabline for single listed buffer", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    local expected = config.hl_inactive_item .. "   awesome.lua   " .. config.hl_autofill
    assert.are.equal(ui.generateTabline(), expected)
  end)

  it("should generate tabline for multiple buffers with active buffer highlight", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    buffer.add(2, "/home/user/project/test.lua")
    buffer.setActive(2)

    local expected = config.hl_inactive_item
      .. "   awesome.lua   "
      .. config.hl_active_item
      .. "   test.lua   "
      .. config.hl_autofill
    assert.are.equal(ui.generateTabline(), expected)
  end)

  it("should resolve buffer name conflicts through tabline generation", function()
    buffer.add(1, "/home/test/project/file.lua")
    buffer.add(2, "/home/exam/project/file.lua")

    local expected = config.hl_inactive_item
      .. "   test/file.lua   "
      .. config.hl_inactive_item
      .. "   exam/file.lua   "
      .. config.hl_autofill
    assert.are.equal(ui.generateTabline(), expected)
  end)
end)
