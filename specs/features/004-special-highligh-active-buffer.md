# Feature Specification: Secure User Password Reset
**Spec ID:** `004-special-highligh-active-buffer`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Special highlight active buffer.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

### Render Update (`lua/buffer-list/render.lua`)
1. Creates new highlight MyTabActive linked to TabLineSel.
2. Use this MyTabActive for active buffer.
