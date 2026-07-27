local buffer = require("buffer-list.buffer")
local command = require("buffer-list.command")
local util = require("buffer-list.util")

describe("Command Module", function()
  before_each(function()
    buffer.clear()
  end)

  it("should handle onBufAdd for valid listed buffer", function()
    local buf_nr = vim.api.nvim_create_buf(true, false)
    command.onBufAdd({ buf = buf_nr })

    local path = vim.api.nvim_buf_get_name(buf_nr)
    assert.are.same(buffer.getBuffers(), { { id = buf_nr, path = path } })
    assert.is_true(util.contains(buffer.getBuffers(), buf_nr))

    vim.api.nvim_buf_delete(buf_nr, { force = true })
  end)

  it("should ignore onBufAdd for unlisted buffer", function()
    local buf_nr = vim.api.nvim_create_buf(false, false)
    command.onBufAdd({ buf = buf_nr })

    assert.is_false(util.contains(buffer.getBuffers(), buf_nr))

    vim.api.nvim_buf_delete(buf_nr, { force = true })
  end)

  it("should handle onBufAdd with nil payload gracefully", function()
    command.onBufAdd(nil)
    command.onBufAdd({})
    assert.are.same(buffer.getBuffers(), {})
  end)

  it("should handle onBufDelete when buffer is deleted", function()
    local buf_nr = vim.api.nvim_create_buf(true, false)
    command.onBufAdd({ buf = buf_nr })
    assert.is_true(util.contains(buffer.getBuffers(), buf_nr))

    command.onBufDelete({ buf = buf_nr })
    assert.is_false(util.contains(buffer.getBuffers(), buf_nr))

    vim.api.nvim_buf_delete(buf_nr, { force = true })
  end)

  it("should handle onBufEnter for valid listed buffer", function()
    local buf_nr = vim.api.nvim_create_buf(true, false)
    command.onBufEnter({ buf = buf_nr })
    assert.are.equal(buffer.getActive(), buf_nr)

    vim.api.nvim_buf_delete(buf_nr, { force = true })
  end)

  it("should ignore onBufEnter for unlisted buffer", function()
    local buf_nr = vim.api.nvim_create_buf(false, false)
    command.onBufEnter({ buf = buf_nr })
    assert.is_nil(buffer.getActive())

    vim.api.nvim_buf_delete(buf_nr, { force = true })
  end)

  it("should handle onBufEnter with nil payload gracefully", function()
    command.onBufEnter(nil)
    command.onBufEnter({})
    assert.is_nil(buffer.getActive())
  end)

  describe("moveRight and moveLeft", function()
    it("should switch to right adjacent buffer on moveRight", function()
      local buf1 = vim.api.nvim_create_buf(true, false)
      local buf2 = vim.api.nvim_create_buf(true, false)

      command.onBufAdd({ buf = buf1 })
      command.onBufAdd({ buf = buf2 })

      vim.api.nvim_set_current_buf(buf1)
      command.onBufEnter({ buf = buf1 })

      command.moveRight()
      assert.are.equal(vim.api.nvim_get_current_buf(), buf2)

      vim.api.nvim_buf_delete(buf1, { force = true })
      vim.api.nvim_buf_delete(buf2, { force = true })
    end)

    it("should switch to left adjacent buffer on moveLeft", function()
      local buf1 = vim.api.nvim_create_buf(true, false)
      local buf2 = vim.api.nvim_create_buf(true, false)

      command.onBufAdd({ buf = buf1 })
      command.onBufAdd({ buf = buf2 })

      vim.api.nvim_set_current_buf(buf2)
      command.onBufEnter({ buf = buf2 })

      command.moveLeft()
      assert.are.equal(vim.api.nvim_get_current_buf(), buf1)

      vim.api.nvim_buf_delete(buf1, { force = true })
      vim.api.nvim_buf_delete(buf2, { force = true })
    end)

    it("should do nothing if no adjacent buffer exists", function()
      local buf1 = vim.api.nvim_create_buf(true, false)
      command.onBufAdd({ buf = buf1 })

      vim.api.nvim_set_current_buf(buf1)
      command.onBufEnter({ buf = buf1 })

      command.moveRight()
      assert.are.equal(vim.api.nvim_get_current_buf(), buf1)

      command.moveLeft()
      assert.are.equal(vim.api.nvim_get_current_buf(), buf1)

      vim.api.nvim_buf_delete(buf1, { force = true })
    end)

    it("should save current window ID when onBufEnter is called", function()
      local buf1 = vim.api.nvim_create_buf(true, false)
      command.onBufAdd({ buf = buf1 })

      local win_id = vim.api.nvim_get_current_win()
      command.onBufEnter({ buf = buf1 })

      assert.are.equal(buffer.getWindow(buf1), win_id)

      vim.api.nvim_buf_delete(buf1, { force = true })
    end)

    it("should reuse saved window handle on moveRight if valid", function()
      local buf1 = vim.api.nvim_create_buf(true, false)
      local buf2 = vim.api.nvim_create_buf(true, false)

      command.onBufAdd({ buf = buf1 })
      command.onBufAdd({ buf = buf2 })

      local current_win = vim.api.nvim_get_current_win()
      buffer.setWindow(buf2, current_win)

      vim.api.nvim_set_current_buf(buf1)
      command.onBufEnter({ buf = buf1 })

      command.moveRight()
      assert.are.equal(vim.api.nvim_get_current_buf(), buf2)
      assert.are.equal(vim.api.nvim_get_current_win(), current_win)

      vim.api.nvim_buf_delete(buf1, { force = true })
      vim.api.nvim_buf_delete(buf2, { force = true })
    end)

    it("should swap buffers on swapRight and swapLeft", function()
      local buf1 = vim.api.nvim_create_buf(true, false)
      local buf2 = vim.api.nvim_create_buf(true, false)

      command.onBufAdd({ buf = buf1 })
      command.onBufAdd({ buf = buf2 })
      buffer.setActive(buf1)

      command.swapRight()
      assert.are.same(buffer.getBuffers(), {
        { id = buf2, path = vim.api.nvim_buf_get_name(buf2) },
        { id = buf1, path = vim.api.nvim_buf_get_name(buf1) },
      })

      command.swapLeft()
      assert.are.same(buffer.getBuffers(), {
        { id = buf1, path = vim.api.nvim_buf_get_name(buf1) },
        { id = buf2, path = vim.api.nvim_buf_get_name(buf2) },
      })

      vim.api.nvim_buf_delete(buf1, { force = true })
      vim.api.nvim_buf_delete(buf2, { force = true })
    end)
  end)

  describe("delete", function()
    it("should do nothing if buffer list length is 1 or less", function()
      local buf1 = vim.api.nvim_create_buf(true, false)
      command.onBufAdd({ buf = buf1 })
      command.onBufEnter({ buf = buf1 })

      command.delete()
      assert.are.same(#buffer.getBuffers(), 1)
      assert.is_true(vim.api.nvim_buf_is_valid(buf1))

      vim.api.nvim_buf_delete(buf1, { force = true })
    end)

    it("should delete active buffer and switch to left adjacent buffer if available", function()
      local buf1 = vim.api.nvim_create_buf(true, false)
      local buf2 = vim.api.nvim_create_buf(true, false)

      command.onBufAdd({ buf = buf1 })
      command.onBufAdd({ buf = buf2 })

      vim.api.nvim_set_current_buf(buf2)
      command.onBufEnter({ buf = buf2 })

      command.delete()
      assert.is_false(vim.api.nvim_buf_is_valid(buf2))
      assert.are.equal(vim.api.nvim_get_current_buf(), buf1)

      vim.api.nvim_buf_delete(buf1, { force = true })
    end)

    it("should delete active buffer and switch to right adjacent buffer if left is not available", function()
      local buf1 = vim.api.nvim_create_buf(true, false)
      local buf2 = vim.api.nvim_create_buf(true, false)

      command.onBufAdd({ buf = buf1 })
      command.onBufAdd({ buf = buf2 })

      vim.api.nvim_set_current_buf(buf1)
      command.onBufEnter({ buf = buf1 })

      command.delete()
      assert.is_false(vim.api.nvim_buf_is_valid(buf1))
      assert.are.equal(vim.api.nvim_get_current_buf(), buf2)

      vim.api.nvim_buf_delete(buf2, { force = true })
    end)
  end)
end)
