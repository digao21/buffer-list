local infrastructure = require("buffer-list.infrastructure")

describe("Infrastructure Module", function()
  it("should validate buffer handles accurately", function()
    assert.is_false(infrastructure.isValid(nil))
    assert.is_false(infrastructure.isValid(0))
    assert.is_false(infrastructure.isValid(-5))
    assert.is_false(infrastructure.isValid(999999))

    local buf_nr = vim.api.nvim_create_buf(true, false)
    assert.is_true(infrastructure.isValid(buf_nr))

    vim.api.nvim_buf_delete(buf_nr, { force = true })
    assert.is_false(infrastructure.isValid(buf_nr))
  end)

  it("should check if buffer is buflisted", function()
    local listed_buf = vim.api.nvim_create_buf(true, false)
    local unlisted_buf = vim.api.nvim_create_buf(false, false)

    assert.is_true(infrastructure.isBuflisted(listed_buf))
    assert.is_false(infrastructure.isBuflisted(unlisted_buf))
    assert.is_false(infrastructure.isBuflisted(999999))

    vim.api.nvim_buf_delete(listed_buf, { force = true })
    vim.api.nvim_buf_delete(unlisted_buf, { force = true })
  end)

  it("should return buffer name or empty string for invalid buffer", function()
    assert.are.equal(infrastructure.getBufPath(999999), "")

    local buf_nr = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(buf_nr, "/tmp/test_buf_file.txt")
    assert.are.equal(infrastructure.getBufPath(buf_nr), "/tmp/test_buf_file.txt")

    vim.api.nvim_buf_delete(buf_nr, { force = true })
  end)

  it("should list all listed buffers", function()
    local listed_buf = vim.api.nvim_create_buf(true, false)
    local unlisted_buf = vim.api.nvim_create_buf(false, false)

    local listed = infrastructure.getListedBuffers()
    local found_listed = false
    local found_unlisted = false

    for _, b in ipairs(listed) do
      if b == listed_buf then
        found_listed = true
      end
      if b == unlisted_buf then
        found_unlisted = true
      end
    end

    assert.is_true(found_listed)
    assert.is_false(found_unlisted)

    vim.api.nvim_buf_delete(listed_buf, { force = true })
    vim.api.nvim_buf_delete(unlisted_buf, { force = true })
  end)

  it("should open buffer if valid and return success status", function()
    assert.is_false(infrastructure.openBuffer(nil))
    assert.is_false(infrastructure.openBuffer(0))
    assert.is_false(infrastructure.openBuffer(999999))

    local buf1 = vim.api.nvim_create_buf(true, false)
    local buf2 = vim.api.nvim_create_buf(true, false)

    vim.api.nvim_set_current_buf(buf1)
    assert.are.equal(vim.api.nvim_get_current_buf(), buf1)

    assert.is_true(infrastructure.openBuffer(buf2))
    assert.are.equal(vim.api.nvim_get_current_buf(), buf2)

    vim.api.nvim_buf_delete(buf1, { force = true })
    vim.api.nvim_buf_delete(buf2, { force = true })
  end)

  it("should return current window ID and validate window handles", function()
    local current_win = infrastructure.getCurrentWin()
    assert.is_number(current_win)
    assert.is_true(infrastructure.isWinValid(current_win))
    assert.is_false(infrastructure.isWinValid(nil))
    assert.is_false(infrastructure.isWinValid(0))
    assert.is_false(infrastructure.isWinValid(-1))
    assert.is_false(infrastructure.isWinValid(999999))
  end)

  it("should open buffer in target window if valid or fallback to current window", function()
    local buf1 = vim.api.nvim_create_buf(true, false)
    local buf2 = vim.api.nvim_create_buf(true, false)
    local current_win = infrastructure.getCurrentWin()

    -- Test opening in valid target window (same window)
    assert.is_true(infrastructure.openBuffer(buf2, current_win))
    assert.are.equal(vim.api.nvim_get_current_buf(), buf2)
    assert.are.equal(vim.api.nvim_get_current_win(), current_win)

    -- Test fallback when target window is invalid
    assert.is_true(infrastructure.openBuffer(buf1, 999999))
    assert.are.equal(vim.api.nvim_get_current_buf(), buf1)

    vim.api.nvim_buf_delete(buf1, { force = true })
    vim.api.nvim_buf_delete(buf2, { force = true })
  end)

  it("should preserve current window focus when opening buffer in a different window", function()
    local buf1 = vim.api.nvim_create_buf(true, false)
    local buf2 = vim.api.nvim_create_buf(true, false)

    local win1 = vim.api.nvim_get_current_win()
    local win2 = vim.api.nvim_open_win(buf1, true, {
      split = "right",
      width = 20,
      height = 20,
    })

    -- Focus win1
    vim.api.nvim_set_current_win(win1)
    assert.are.equal(vim.api.nvim_get_current_win(), win1)

    -- Open buf2 in win2 while focused on win1
    assert.is_true(infrastructure.openBuffer(buf2, win2))

    -- win2 buffer should be updated to buf2
    assert.are.equal(vim.api.nvim_win_get_buf(win2), buf2)

    -- Active window focus must remain win1
    assert.are.equal(vim.api.nvim_get_current_win(), win1)

    vim.api.nvim_win_close(win2, true)
    vim.api.nvim_buf_delete(buf1, { force = true })
    vim.api.nvim_buf_delete(buf2, { force = true })
  end)

  it("should trigger redraw without errors", function()
    assert.has_no.errors(function()
      infrastructure.redraw()
    end)
  end)

  it("should delete buffer if valid", function()
    assert.is_false(infrastructure.deleteBuffer(nil))
    assert.is_false(infrastructure.deleteBuffer(0))
    assert.is_false(infrastructure.deleteBuffer(999999))

    local buf1 = vim.api.nvim_create_buf(true, false)
    assert.is_true(infrastructure.isValid(buf1))
    assert.is_true(infrastructure.deleteBuffer(buf1))
    assert.is_false(infrastructure.isValid(buf1))
  end)
end)
