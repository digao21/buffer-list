# Feature Specification: Name Conflict Resolution
**Spec ID:** `012-name-conflict-resolution`
**Status:** Draft / Ready for AI Execution

---

## 1. Objective and Scope
*   **Objective:** Resolve the conflict when two files has the same name.

---

## 2. Technical Stack and Dependencies
*   **Language/Runtime:** Lua 5.1, NeoVim v0.11.5, LuaJIT 2.1

---

## 3. Name Resolution

When two files has the same name, use the path to resolve the conflict.
Reuse the OS file separator.
Follow those examples.

### Example 1
File 1: `/home/test/project/file.lua` -> `test/file.lua`
File 2: `/home/exam/project/file.lua` -> `exam/file.lua`

### Example 2
File 1: `/home/agua/project/test/file.lua` -> `agua/file.lua`
File 2: `/home/rosa/project/exam/file.lua` -> `rosa/file.lua`

### Example 3
File 1: `` -> `[No Name] 1`
File 2: `` -> `[No Name] 2`

### Example 4
File 1: `/home/file.lua` -> `file.lua`
File 2: `/home/rosa/file.lua` -> `rosa/file.lua`

### Example 5
File 1: `/home/agua/project/test/file.lua` -> `agua/file.lua`
File 2: `/home/rosa/project/exam/file.lua` -> `rosa/file.lua`
File 3: `/home/pata/project/exam/file.lua` -> `pata/file.lua`

### Example 5
File 1: `/home/agua/project/test/file.lua` -> `agua/file.lua`
File 2: `/home/rosa/git/exam/file.lua` -> `rosa/git/file.lua`
File 3: `/home/rosa/scm/exam/file.lua` -> `rosa/scm/file.lua`
