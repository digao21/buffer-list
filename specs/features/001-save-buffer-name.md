# Feature Specification: Secure User Password Reset
**Spec ID:** `001-save-buffer-name`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Save buffer name from listed buffers.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

### Handle new Buffer
1. When add a buffer to `lua/buffer-list/buffer.lua` pass full name as returned from vim API.
2. Save the buffer path alongside the buffer id. Use the following table schema.
```
{
    buffer_id = { id = 1, path = '/home/example/git/project/awesome.lua'
}
```
