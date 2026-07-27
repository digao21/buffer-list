# Feature Specification: Command Swap Right
**Spec ID:** `008-command-swap-right`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Create commands to swap adjacent buffers in the list.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

### Swap Buffer Method
1. Creates the method `swapBuffer` on file `lua/buffer-list/buffer.lua`.
2. The method receives a number as a paramether.
3. Given the number x, it swaps the active buffer to the buffer x to the right if available.
   Otherwise, does nothing.
4. If x is negative, do the same to the left.

### Command Swap Right
1. Creates the command `BufferList swap-right` on `plugin/buffer-list.lua` that calls the handler on `lua/buffer-list/command.lua`.
2. The handler calls `buffer.swapBuffer(1)`.

### Command Swap Left
1. The command `BufferList swap-left` is analogous but calls `buffer.swapBuffer(-1)`.
