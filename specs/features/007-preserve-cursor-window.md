# Feature Specification: Preserve Cursor Window
**Spec ID:** `007-preserve-cursor-window`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Preserve current window if openning a buffer on a different window.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

### Preserve Current Window
1. When open a file, if it is openning on a different window, return to current window afterward.
