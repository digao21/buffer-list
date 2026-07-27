# Feature Specification: Command Delete
**Spec ID:** `010-command-delete`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Implements the command delete.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

###  Delete Command Handler
1. Implements the delete command handler at `lua/buffer-list/command`.
2. The handler should evaluate if the buffer list is bigger then 1.
   If it is not, do nothing.
3. Gets the active buffer and the left adjacent one.
   If the left one is not available, get the right one.
4. Calls `lua/buffer-list/infrastucture.lua` to delete the active buffer then open the adjacent one.
