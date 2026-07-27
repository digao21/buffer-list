# Feature Specification: Bugfix Redraw After Swap
**Spec ID:** `009-buffix-redraw-after-swap`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** After swap redraw UI.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

###  Redraw After Swap
1. Creates the method redraw on `lua/buffer-list/infrastructure.lua`.
2. In the end of the command swap, calls redraw.
