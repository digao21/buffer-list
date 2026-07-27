# Feature Specification: Bugfix Open Before Delete
**Spec ID:** `011-bugfix-open-before-delete`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Fix bug on delete command.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

###  Bugfix Delete Command
1. Change how the delete command works, open the new buffer before delete the old one.
