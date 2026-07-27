# Feature Specification: Secure User Password Reset
**Spec ID:** `002-render-tabline`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Render tabline containing the names of open buffers.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Implementation Details

### Generate Tabline String
1. `lua/buffer-list/render.lua` creates MyTabInactive highlights linked to TabLineFil if it doesn't exists.
2. `lua/buffer-list/render.lua` creates MyTabFill highlights with background NONE if it doesn't exists.
3. `lua/buffer-list/render.lua` gets the list of buffers from `lua/buffer-list/buffer.lua`.
4. For each buffer, parses the file full name/path to filename only.
   Eg.: parses `/home/example/project/awesome.lua` to `awesome.lua`.
5. Generate the tabline string:
    1. Concatenate each buffer name.
    2. For each buffer name, add 3 whitespaces as padding for each side (prefix and suffix).
    3. Give to each filename the MyTabInactive highlight.
    4. As a final step, sufix the tabline string with the MyTabFill highlight.

### Bind new Tabline String to NeoVim Tabline
1. Create a new global method `_G.BufferListTabline` which basically returns the string from previous section.
2. Makes NeoVim use this method to fill the tabline. Eg.: `vim.o.tabline = "%!v:lua.BufferListTabline()"`
