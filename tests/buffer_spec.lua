local buffer = require("buffer-list.buffer")
local util = require("buffer-list.util")

describe("Buffer Module", function()
  before_each(function()
    buffer.clear()
  end)

  it("should start with an empty buffer list", function()
    assert.are.same(buffer.getBuffers(), {})
  end)

  it("should add valid buffers with paths to the list", function()
    assert.is_true(buffer.add(1, "/path/file1.lua"))
    assert.is_true(buffer.add(2, "/path/file2.lua"))
    assert.are.same(buffer.getBuffers(), {
      { id = 1, path = "/path/file1.lua" },
      { id = 2, path = "/path/file2.lua" },
    })
  end)

  it("should default to empty string if buffer path is omitted", function()
    assert.is_true(buffer.add(1))
    assert.are.same(buffer.getBuffers(), {
      { id = 1, path = "" },
    })
  end)

  it("should not add duplicate buffers", function()
    assert.is_true(buffer.add(1, "/path/file1.lua"))
    assert.is_false(buffer.add(1, "/path/file1.lua"))
    assert.are.same(buffer.getBuffers(), {
      { id = 1, path = "/path/file1.lua" },
    })
  end)

  it("should ignore invalid buffer numbers on add", function()
    assert.is_false(buffer.add(nil))
    assert.is_false(buffer.add(0))
    assert.is_false(buffer.add(-1))
    assert.are.same(buffer.getBuffers(), {})
  end)

  it("should check if buffer list contains a buffer", function()
    buffer.add(10, "/path/file10.lua")
    assert.is_true(util.contains(buffer.getBuffers(), 10))
    assert.is_false(util.contains(buffer.getBuffers(), 20))
  end)

  it("should remove existing buffers", function()
    buffer.add(1, "file1")
    buffer.add(2, "file2")
    buffer.add(3, "file3")

    assert.is_true(buffer.remove(2))
    assert.are.same(buffer.getBuffers(), {
      { id = 1, path = "file1" },
      { id = 3, path = "file3" },
    })

    assert.is_false(buffer.remove(2))
    assert.are.same(buffer.getBuffers(), {
      { id = 1, path = "file1" },
      { id = 3, path = "file3" },
    })
  end)

  it("should ignore invalid inputs on remove", function()
    buffer.add(1, "file1")
    assert.is_false(buffer.remove(nil))
    assert.are.same(buffer.getBuffers(), {
      { id = 1, path = "file1" },
    })
  end)

  it("should clear all buffers", function()
    buffer.add(1, "file1")
    buffer.add(2, "file2")
    buffer.clear()
    assert.are.same(buffer.getBuffers(), {})
  end)

  it("should return a copy of the buffer list so internal state is protected", function()
    buffer.add(1, "file1")
    local bufs = buffer.getBuffers()
    table.insert(bufs, { id = 999, path = "fake" })
    assert.are.same(buffer.getBuffers(), {
      { id = 1, path = "file1" },
    })
  end)

  it("should set and get active buffer", function()
    assert.is_nil(buffer.getActive())
    assert.is_true(buffer.setActive(5))
    assert.are.equal(buffer.getActive(), 5)
  end)

  it("should ignore invalid buffer numbers on setActive", function()
    assert.is_false(buffer.setActive(nil))
    assert.is_false(buffer.setActive(0))
    assert.is_false(buffer.setActive(-1))
    assert.is_nil(buffer.getActive())
  end)

  it("should reset active buffer on remove if active buffer is removed", function()
    buffer.add(1, "file1")
    buffer.add(2, "file2")
    buffer.setActive(2)
    assert.are.equal(buffer.getActive(), 2)

    buffer.remove(1)
    assert.are.equal(buffer.getActive(), 2)

    buffer.remove(2)
    assert.is_nil(buffer.getActive())
  end)

  it("should reset active buffer on clear", function()
    buffer.add(1, "file1")
    buffer.setActive(1)
    assert.are.equal(buffer.getActive(), 1)

    buffer.clear()
    assert.is_nil(buffer.getActive())
  end)

  describe("getAdjacentBuffer", function()
    it("should return nil if active_buffer is not set", function()
      buffer.add(1, "file1")
      buffer.add(2, "file2")
      assert.is_nil(buffer.getAdjacentBuffer(1))
    end)

    it("should return nil if offset is invalid or nil", function()
      buffer.add(1, "file1")
      buffer.setActive(1)
      assert.is_nil(buffer.getAdjacentBuffer(nil))
      assert.is_nil(buffer.getAdjacentBuffer("1"))
    end)

    it("should return right adjacent buffer ID when offset is 1", function()
      buffer.add(10, "file1")
      buffer.add(20, "file2")
      buffer.add(30, "file3")
      buffer.setActive(20)

      assert.are.equal(buffer.getAdjacentBuffer(1), 30)
    end)

    it("should return left adjacent buffer ID when offset is -1", function()
      buffer.add(10, "file1")
      buffer.add(20, "file2")
      buffer.add(30, "file3")
      buffer.setActive(20)

      assert.are.equal(buffer.getAdjacentBuffer(-1), 10)
    end)

    it("should return nil when moving right beyond boundary", function()
      buffer.add(10, "file1")
      buffer.add(20, "file2")
      buffer.setActive(20)

      assert.is_nil(buffer.getAdjacentBuffer(1))
    end)

    it("should return nil when moving left beyond boundary", function()
      buffer.add(10, "file1")
      buffer.add(20, "file2")
      buffer.setActive(10)

      assert.is_nil(buffer.getAdjacentBuffer(-1))
    end)

    it("should return nil if active_buffer is not in managed_buffers", function()
      buffer.add(10, "file1")
      buffer.setActive(999)

      assert.is_nil(buffer.getAdjacentBuffer(1))
      assert.is_nil(buffer.getAdjacentBuffer(-1))
    end)
  end)

  describe("window management", function()
    it("should set and get window handle for a buffer", function()
      buffer.add(1, "file1")
      assert.is_nil(buffer.getWindow(1))
      assert.is_true(buffer.setWindow(1, 1001))
      assert.are.equal(buffer.getWindow(1), 1001)
    end)

    it("should handle invalid inputs for setWindow and getWindow", function()
      assert.is_false(buffer.setWindow(nil, 1001))
      assert.is_false(buffer.setWindow(0, 1001))
      assert.is_false(buffer.setWindow(999, 1001))
      assert.is_nil(buffer.getWindow(nil))
      assert.is_nil(buffer.getWindow(0))
      assert.is_nil(buffer.getWindow(999))
    end)

    it("should save window handle when setActive is called with win_id", function()
      buffer.add(1, "file1")
      buffer.setActive(1, 1002)
      assert.are.equal(buffer.getActive(), 1)
      assert.are.equal(buffer.getWindow(1), 1002)
    end)
  end)

  describe("swapBuffer", function()
    it("should return false if active_buffer is not set or not in list", function()
      buffer.add(1, "file1")
      buffer.add(2, "file2")
      assert.is_false(buffer.swapBuffer(1))

      buffer.setActive(999)
      assert.is_false(buffer.swapBuffer(1))
    end)

    it("should return false for invalid offset", function()
      buffer.add(1, "file1")
      buffer.setActive(1)
      assert.is_false(buffer.swapBuffer(nil))
      assert.is_false(buffer.swapBuffer("1"))
    end)

    it("should swap active buffer to the right when offset is 1", function()
      buffer.add(10, "file1")
      buffer.add(20, "file2")
      buffer.add(30, "file3")
      buffer.setActive(10)

      assert.is_true(buffer.swapBuffer(1))
      assert.are.same(buffer.getBuffers(), {
        { id = 20, path = "file2" },
        { id = 10, path = "file1" },
        { id = 30, path = "file3" },
      })
      assert.are.equal(buffer.getActive(), 10)
    end)

    it("should swap active buffer to the left when offset is -1", function()
      buffer.add(10, "file1")
      buffer.add(20, "file2")
      buffer.add(30, "file3")
      buffer.setActive(30)

      assert.is_true(buffer.swapBuffer(-1))
      assert.are.same(buffer.getBuffers(), {
        { id = 10, path = "file1" },
        { id = 30, path = "file3" },
        { id = 20, path = "file2" },
      })
      assert.are.equal(buffer.getActive(), 30)
    end)

    it("should return false when swapping right at upper boundary", function()
      buffer.add(10, "file1")
      buffer.add(20, "file2")
      buffer.setActive(20)

      assert.is_false(buffer.swapBuffer(1))
      assert.are.same(buffer.getBuffers(), {
        { id = 10, path = "file1" },
        { id = 20, path = "file2" },
      })
    end)

    it("should return false when swapping left at lower boundary", function()
      buffer.add(10, "file1")
      buffer.add(20, "file2")
      buffer.setActive(10)

      assert.is_false(buffer.swapBuffer(-1))
      assert.are.same(buffer.getBuffers(), {
        { id = 10, path = "file1" },
        { id = 20, path = "file2" },
      })
    end)
  end)
end)
