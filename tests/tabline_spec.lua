local config = require("buffer-list.config")
local tabline = require("buffer-list.ui.tabline")

describe("Tabline Module", function()
  it("should generate tabline string for empty buffer list", function()
    local result = tabline.generateTabline(0, {})
    assert.are.equal(result, config.hl_autofill)
  end)

  it("should generate tabline string with single buffer and padding", function()
    local buffers = {
      { id = 1, name = "awesome.lua" },
    }
    local result = tabline.generateTabline(0, buffers)
    local expected = config.hl_inactive_item .. "   awesome.lua   " .. config.hl_autofill
    assert.are.equal(result, expected)
  end)

  it("should apply active highlight for the active buffer and inactive for others", function()
    local buffers = {
      { id = 1, name = "awesome.lua" },
      { id = 2, name = "test.lua" },
    }
    local result = tabline.generateTabline(2, buffers)
    local expected = config.hl_inactive_item
      .. "   awesome.lua   "
      .. config.hl_active_item
      .. "   test.lua   "
      .. config.hl_autofill
    assert.are.equal(result, expected)
  end)
end)
