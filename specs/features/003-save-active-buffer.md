# Feature Specification: Secure User Password Reset
**Spec ID:** `003-save-active-buffer`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Save active buffer.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

### Save Active Buffer
1. `lua/buffer-list/buffer.lua` must be able to save the active buffer

### Create Autocommand and Handler
1. `lua/buffer-list/command.lua` add new handler to the new autocommand.
    The handler must call `lua/buffer-list/buffer.lua` to save the active handler.
2. `plugin/buffer-list.lua` should create the new autocommand for BufEnter and call the handler from `lua/buffer-list/command.lua`.
