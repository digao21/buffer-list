local buffer = require("buffer-list.buffer")
local array = require("buffer-list.util.array")

describe("Plugin Autocommands Integration", function()
  before_each(function()
    buffer.clear()
    -- require plugin to set up autocommands
    dofile("plugin/buffer-list.lua")
  end)

  it("should automatically add buffer when created and delete when wiped", function()
    local buf_nr = vim.api.nvim_create_buf(true, false)

    -- Trigger BufAdd autocommand event explicitly or let Neovim trigger it
    vim.api.nvim_exec_autocmds("BufAdd", { buffer = buf_nr })
    assert.is_true(array.contains(buffer.getBuffers(), buf_nr))

    -- Trigger BufDelete autocommand event
    vim.api.nvim_exec_autocmds("BufDelete", { buffer = buf_nr })
    assert.is_false(array.contains(buffer.getBuffers(), buf_nr))

    vim.api.nvim_buf_delete(buf_nr, { force = true })
  end)

  it("should set active buffer when BufEnter event is triggered", function()
    local buf_nr = vim.api.nvim_create_buf(true, false)

    vim.api.nvim_exec_autocmds("BufEnter", { buffer = buf_nr })
    assert.are.equal(buffer.getActive(), buf_nr)

    vim.api.nvim_buf_delete(buf_nr, { force = true })
  end)

  it("should execute BufferList move-right and move-left commands", function()
    local buf1 = vim.api.nvim_create_buf(true, false)
    local buf2 = vim.api.nvim_create_buf(true, false)

    vim.api.nvim_exec_autocmds("BufAdd", { buffer = buf1 })
    vim.api.nvim_exec_autocmds("BufAdd", { buffer = buf2 })

    vim.api.nvim_set_current_buf(buf1)
    vim.api.nvim_exec_autocmds("BufEnter", { buffer = buf1 })

    vim.cmd("BufferList move-right")
    assert.are.equal(vim.api.nvim_get_current_buf(), buf2)

    vim.api.nvim_exec_autocmds("BufEnter", { buffer = buf2 })
    vim.cmd("BufferList move-left")
    assert.are.equal(vim.api.nvim_get_current_buf(), buf1)

    vim.api.nvim_buf_delete(buf1, { force = true })
    vim.api.nvim_buf_delete(buf2, { force = true })
  end)

  it("should execute BufferList swap-right and swap-left commands", function()
    local buf1 = vim.api.nvim_create_buf(true, false)
    local buf2 = vim.api.nvim_create_buf(true, false)

    vim.api.nvim_exec_autocmds("BufAdd", { buffer = buf1 })
    vim.api.nvim_exec_autocmds("BufAdd", { buffer = buf2 })

    vim.api.nvim_set_current_buf(buf1)
    vim.api.nvim_exec_autocmds("BufEnter", { buffer = buf1 })

    vim.cmd("BufferList swap-right")
    assert.are.same(buffer.getBuffers(), {
      { id = buf2, path = vim.api.nvim_buf_get_name(buf2) },
      { id = buf1, path = vim.api.nvim_buf_get_name(buf1) },
    })

    vim.cmd("BufferList swap-left")
    assert.are.same(buffer.getBuffers(), {
      { id = buf1, path = vim.api.nvim_buf_get_name(buf1) },
      { id = buf2, path = vim.api.nvim_buf_get_name(buf2) },
    })

    vim.api.nvim_buf_delete(buf1, { force = true })
    vim.api.nvim_buf_delete(buf2, { force = true })
  end)

  it("should execute BufferList delete command", function()
    local buf1 = vim.api.nvim_create_buf(true, false)
    local buf2 = vim.api.nvim_create_buf(true, false)

    vim.api.nvim_exec_autocmds("BufAdd", { buffer = buf1 })
    vim.api.nvim_exec_autocmds("BufAdd", { buffer = buf2 })

    vim.api.nvim_set_current_buf(buf2)
    vim.api.nvim_exec_autocmds("BufEnter", { buffer = buf2 })

    vim.cmd("BufferList delete")
    assert.is_false(vim.api.nvim_buf_is_valid(buf2))
    assert.are.equal(vim.api.nvim_get_current_buf(), buf1)

    vim.api.nvim_buf_delete(buf1, { force = true })
  end)
end)
