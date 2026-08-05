local config = require("buffer-list.config")
local tabline = require("buffer-list.ui.tabline")

describe("Tabline Module", function()
  before_each(function()
    tabline.resetWindow()
  end)

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

  it("Basic truncate right 1", function()
    local buffers = {
      { id = 1, name = "abc" },
      { id = 2, name = "def" },
      { id = 3, name = "ghi" },
    }

    local result = tabline.generateTabline(1, buffers, 9)

    local expected = config.hl_active_item .. "   abc..." .. config.hl_autofill

    assert.are.equal(result, expected)
  end)

  it("Basic truncate right 2", function()
    local buffers = {
      { id = 1, name = "abc" },
      { id = 2, name = "def" },
      { id = 3, name = "ghi" },
    }

    local result = tabline.generateTabline(1, buffers, 10)

    local expected = config.hl_active_item .. "   abc ..." .. config.hl_autofill
    assert.are.equal(result, expected)
  end)

  it("Basic truncate right 3", function()
    local buffers = {
      { id = 1, name = "abc" },
      { id = 2, name = "def" },
      { id = 3, name = "ghi" },
    }

    local result = tabline.generateTabline(1, buffers, 11)

    local expected = config.hl_active_item .. "   abc  ..." .. config.hl_autofill

    assert.are.equal(result, expected)
  end)

  it("Basic truncate right 4", function()
    local buffers = {
      { id = 1, name = "abc" },
      { id = 2, name = "def" },
      { id = 3, name = "ghi" },
    }

    local result = tabline.generateTabline(1, buffers, 12)

    local expected = config.hl_active_item .. "   abc   ..." .. config.hl_autofill

    assert.are.equal(result, expected)
  end)

  it("Basic truncate right 5", function()
    local buffers = {
      { id = 1, name = "abc" },
      { id = 2, name = "def" },
      { id = 3, name = "ghi" },
    }

    local result = tabline.generateTabline(1, buffers, 13)

    local expected = config.hl_active_item .. "   abc   " .. config.hl_inactive_item .. "d..." .. config.hl_autofill

    assert.are.equal(result, expected)
  end)
--
--  it("Basic truncate right 6", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 14)
--
--    local expected = config.hl_active_item .. "   abc   " .. config.hl_inactive_item .. "de..." .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 7", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 15)
--
--    local expected = config.hl_active_item .. "   abc   " .. config.hl_inactive_item .. "def..." .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 8", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 16)
--
--    local expected = config.hl_active_item .. "   abc   " .. config.hl_inactive_item .. " def..." .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 9", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 17)
--
--    local expected = config.hl_active_item .. "   abc   " .. config.hl_inactive_item .. "  def..." .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 10", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 18)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def..."
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 11", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 19)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def ..."
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 12", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 20)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def  ..."
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 13", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 21)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def   ..."
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 14", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 22)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_inactive_item
--      .. "ghi "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 15", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 23)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_inactive_item
--      .. " ghi "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 16", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 24)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_inactive_item
--      .. "  ghi "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 17", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 25)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_inactive_item
--      .. "  ghi  "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 18", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 26)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_inactive_item
--      .. "   ghi  "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate right 19", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(1, buffers, 27)
--
--    local expected = config.hl_active_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_inactive_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 1", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 9)
--
--    local expected = config.hl_active_item .. "   ghi   " .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 2", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 10)
--
--    local expected = config.hl_inactive_item .. "." .. config.hl_active_item .. "   ghi   " .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 3", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 11)
--
--    local expected = config.hl_inactive_item .. ".." .. config.hl_active_item .. "   ghi   " .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 4", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 12)
--
--    local expected = config.hl_inactive_item .. "..." .. config.hl_active_item .. "   ghi   " .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 5", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 13)
--
--    local expected = config.hl_inactive_item .. "...f" .. config.hl_active_item .. "   ghi   " .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 6", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 14)
--
--    local expected = config.hl_inactive_item .. "...ef" .. config.hl_active_item .. "   ghi   " .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 7", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 15)
--
--    local expected = config.hl_inactive_item .. "...def" .. config.hl_active_item .. "   ghi   " .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 8", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 16)
--
--    local expected = config.hl_inactive_item .. "...def " .. config.hl_active_item .. "   ghi   " .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 9", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 17)
--
--    local expected = config.hl_inactive_item .. "...def  " .. config.hl_active_item .. "   ghi   " .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 10", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 18)
--
--    local expected = config.hl_inactive_item
--      .. "...def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 11", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 19)
--
--    local expected = config.hl_inactive_item
--      .. "... def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 12", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 20)
--
--    local expected = config.hl_inactive_item
--      .. "...  def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 13", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 21)
--
--    local expected = config.hl_inactive_item
--      .. "...   def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 14", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 22)
--
--    local expected = config.hl_inactive_item
--      .. " abc"
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 15", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 23)
--
--    local expected = config.hl_inactive_item
--      .. " abc "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 16", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 24)
--
--    local expected = config.hl_inactive_item
--      .. "  abc "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 17", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 25)
--
--    local expected = config.hl_inactive_item
--      .. "  abc  "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 18", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 26)
--
--    local expected = config.hl_inactive_item
--      .. "   abc  "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
--
--  it("Basic truncate left 19", function()
--    local buffers = {
--      { id = 1, name = "abc" },
--      { id = 2, name = "def" },
--      { id = 3, name = "ghi" },
--    }
--
--    local result = tabline.generateTabline(3, buffers, 27)
--
--    local expected = config.hl_inactive_item
--      .. "   abc   "
--      .. config.hl_inactive_item
--      .. "   def   "
--      .. config.hl_active_item
--      .. "   ghi   "
--      .. config.hl_autofill
--
--    assert.are.equal(result, expected)
--  end)
end)
