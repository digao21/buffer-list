# Architectural Specification: System Foundation & Global Design Principles
**Spec ID:** `000-architecture-foundation`
**Status:** Approved / Active
**Scope:** Global (Applies to all modules, and AI-generated code within this repository)

---

## 1. System Overview & Core Philosophy
The architecture of this system is built on the principles of **Maintainability and Strict Decoupling**.
We prioritize explicit contracts over implicit magic, modular boundaries over monolithic coupling, and domain logic purity over framework dependency.

### Core Engineering Tenets
*   **Separation of Concerns:** Business logic must remain entirely independent of UI frameworks, database drivers, and external network protocols.
*   **Encapsulation:** Do not make something public that can be private.
*   **Fail Fast & Gracefully:** Errors must be caught early, handled explicitly, and never swallowed silently.
*   **Determinism:** Side effects must be isolated, bounded, and clearly documented.
*   **Simplicity:** Do not add unnecessary code.

---

## 2. Filesystem structure
*   lua/
    *   buffer-list.lua: main entry point exposing `setup()`.
    *   buffer-list/
        *   buffer.lua: handles anything buffer related.
        *   render.lua: generates final ui element to render.
        *   infrastructure.lua: wraps all nvim requests.
            Only this file and `plugin/buffer-list.lua` can direct access nvim API.
            This file implementation is mocked when running on a test environment.
        *   command.lua: implements the plugin command and event handlers.
        *   util.lua: provides general utility helper functions.
*   plugin/
    *   buffer-list.lua: initializes the plugin.
        Creates nvim commands and autocommands.
        Can access vim API directly.

---

## 3. Lazy Load Optimization
To optimize initialization, `plugin/buffer-list.lua` only loads other modules at callback and if it wasn't loaded before.
