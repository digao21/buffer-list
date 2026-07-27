# Feature Specification: Move Right Command
**Spec ID:** `005-move-right-command`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Create a command that allows the user to swap two adjacent buffers on list.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

### Get Adjacent Buffer
1. Implement the method `getAdjacentBuffer` on moduel `plugin/buffer-list/buffer.lua`.
2. It should receive a number and returns a number or nil.
3. Look for the buffer with x positions to the right of the active buffer.
    1. If it exists, return the buffer.
    2. Otherwise returns null.
4. If x is negative do the same process to the left.

### Command `BufferList move-right`
1. Creates the command `BufferList move-right` on `plugin/buffer-list.lua`, use the handler from `lua/buffer-list/command.lua`.
2. Implements the `lua/buffer-list/command.lua` as follows:
    1. Get the adjacent buffer with `getAdjacentBuffer(1)`.
    2. If it exists, calls infrastucture to open the buffer.

### Command `BufferList move-left`
1. Equivalent to `move-right` but uses -1 on `getAdjacentBuffer` instead of 1.
