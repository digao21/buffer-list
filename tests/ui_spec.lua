local buffer = require("buffer-list.buffer")
local config = require("buffer-list.config")
local ui = require("buffer-list.ui")

describe("UI Module", function()
  before_each(function()
    buffer.clear()
  end)

  it("should generate tabline for empty buffer list", function()
    assert.are.equal(ui.generateTabline(), config.hl_autofill)
  end)

  it("should generate tabline with single buffer filename and 3 spaces padding", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    assert.are.equal(ui.generateTabline(), config.hl_inactive_item .. "   awesome.lua   " .. config.hl_autofill)
  end)

  it("should generate tabline for multiple buffers", function()
    buffer.add(1, "/home/user/project/awesome.lua")
    buffer.add(2, "/home/user/project/test.lua")
    local expected = config.hl_inactive_item
      .. "   awesome.lua   "
      .. config.hl_inactive_item
      .. "   test.lua   "
      .. config.hl_autofill
    assert.are.equal(ui.generateTabline(), expected)
  end)

  it("should handle empty or unnamed buffers gracefully", function()
    buffer.add(1, "")
    assert.are.equal(ui.generateTabline(), config.hl_inactive_item .. "   [No Name]   " .. config.hl_autofill)
  end)

  it("should use active highlight for the active buffer", function()
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

  describe("Name Conflict Resolution", function()
    it("should resolve conflict using first differing directory component (Example 1)", function()
      buffer.add(1, "/home/test/project/file.lua")
      buffer.add(2, "/home/exam/project/file.lua")

      local expected = config.hl_inactive_item
        .. "   test/file.lua   "
        .. config.hl_inactive_item
        .. "   exam/file.lua   "
        .. config.hl_autofill
      assert.are.equal(ui.generateTabline(), expected)
    end)

    it("should resolve conflict using first differing directory component (Example 2)", function()
      buffer.add(1, "/home/agua/project/test/file.lua")
      buffer.add(2, "/home/rosa/project/exam/file.lua")

      local expected = config.hl_inactive_item
        .. "   agua/file.lua   "
        .. config.hl_inactive_item
        .. "   rosa/file.lua   "
        .. config.hl_autofill
      assert.are.equal(ui.generateTabline(), expected)
    end)

    it("should resolve conflict for multiple unnamed buffers (Example 3)", function()
      buffer.add(1, "")
      buffer.add(2, "")

      local expected = config.hl_inactive_item
        .. "   [No Name] 1   "
        .. config.hl_inactive_item
        .. "   [No Name] 2   "
        .. config.hl_autofill
      assert.are.equal(ui.generateTabline(), expected)
    end)

    it("should resolve conflict when one file has shorter path (Example 4)", function()
      buffer.add(1, "/home/file.lua")
      buffer.add(2, "/home/rosa/file.lua")

      local expected = config.hl_inactive_item
        .. "   file.lua   "
        .. config.hl_inactive_item
        .. "   rosa/file.lua   "
        .. config.hl_autofill
      assert.are.equal(ui.generateTabline(), expected)
    end)

    it("should resolve conflict for 3 files with unique directory component (Example 5.1)", function()
      buffer.add(1, "/home/agua/project/test/file.lua")
      buffer.add(2, "/home/rosa/project/exam/file.lua")
      buffer.add(3, "/home/pata/project/exam/file.lua")

      local expected = config.hl_inactive_item
        .. "   agua/file.lua   "
        .. config.hl_inactive_item
        .. "   rosa/file.lua   "
        .. config.hl_inactive_item
        .. "   pata/file.lua   "
        .. config.hl_autofill
      assert.are.equal(ui.generateTabline(), expected)
    end)

    it("should resolve conflict for 3 files with branching directories (Example 5.2)", function()
      buffer.add(1, "/home/agua/project/test/file.lua")
      buffer.add(2, "/home/rosa/git/exam/file.lua")
      buffer.add(3, "/home/rosa/scm/exam/file.lua")

      local expected = config.hl_inactive_item
        .. "   agua/file.lua   "
        .. config.hl_inactive_item
        .. "   rosa/git/file.lua   "
        .. config.hl_inactive_item
        .. "   rosa/scm/file.lua   "
        .. config.hl_autofill
      assert.are.equal(ui.generateTabline(), expected)
    end)
  end)
end)
