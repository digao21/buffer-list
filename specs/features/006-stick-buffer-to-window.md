# Feature Specification: Save Last Window
**Spec ID:** `006-stick-buffer-to-window`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Save the last window a buffer was opened and reuse it to open the buffer.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

### Save Last Window
1. When a Buffer is opened save the window on `lua/buffer-list/buffer.lua`.

### Open Buffer on Same Window
1. When open a buffer try to reuse the last window it was opened.
    1. Validate if the window is still available.
    2. If it is not available use current window.
