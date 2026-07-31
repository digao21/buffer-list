# Buffer List (`buffer-list.nvim`)

A Neovim plugin to manage and track active buffers in real time.

## Features

- **Buffer Tracking**: Automatically tracks listed buffers and active buffer in Neovim when created (`BufAdd`/`BufCreate`), entered (`BufEnter`), or deleted/wiped (`BufDelete`/`BufWipeout`).
- **Tabline Rendering**: Renders a tabline list of buffer names with customizable highlights (`MyTabActive`, `MyTabInactive`, `MyTabFill`).
- **Buffer Navigation**: Navigate between adjacent buffers in the buffer list using `:BufferList move-right` and `:BufferList move-left`.
- **Window Stickiness**: Remembers the last window each buffer was opened in and reuses that window handle when navigating back to it (falling back gracefully to the current window if closed).
- **Cursor Window Preservation**: Preserves focus on the active window when a buffer is opened in a different target window.
- **Buffer Reordering**: Swap positions of adjacent buffers in the list using `:BufferList swap-right` and `:BufferList swap-left`.
- **Name Conflict Resolution**: Automatically resolves conflicting filenames by prefixing the first differing directory component from the path using the OS file separator.
- **Decoupled Architecture**: Strictly separates Neovim API bindings (`infrastructure.lua`), buffer state storage (`buffer.lua`), tabline rendering (`ui/init.lua`), and event handling (`command.lua`).


## Commands

- `:BufferList move-right`: Switch to the next buffer to the right in the buffer list.
- `:BufferList move-left`: Switch to the previous buffer to the left in the buffer list.
- `:BufferList swap-right`: Swap the active buffer's position with the adjacent buffer to the right.
- `:BufferList swap-left`: Swap the active buffer's position with the adjacent buffer to the left.
- `:BufferList delete`: Delete the active buffer and switch to an adjacent buffer (if more than 1 buffer exists).

## Module Overview

- `lua/buffer-list.lua`: Main entry point module exposing `setup()`.
- `lua/buffer-list/infrastructure.lua`: Wraps Neovim API calls (`vim.api`, `vim.bo`, `vim.cmd.redrawtabline`, `vim.api.nvim_win_*`, `deleteBuffer`).
- `lua/buffer-list/buffer.lua`: Maintains internal list of active listed buffers (`{ id = number, path = string, win = number|nil }`), tracks current active buffer ID (`setActive`/`getActive`), manages associated window handles (`setWindow`/`getWindow`), finds adjacent buffers (`getAdjacentBuffer`), and swaps buffer positions (`swapBuffer`).
- `lua/buffer-list/ui/init.lua`: Generates the tabline string (`_G.BufferListTabline`) and sets up default highlights.
- `lua/buffer-list/ui/name-parser.lua`: Transforms buffer paths into display names, automatically resolving filename conflicts using path directory components.
- `lua/buffer-list/util.lua`: Provides generic helper utilities such as `util.contains`.
- `lua/buffer-list/command.lua`: Event handlers for autocommand events, user commands (`moveRight`/`moveLeft`, `swapRight`/`swapLeft`, `delete`), window tracking, and buffer lifecycle logic.
- `plugin/buffer-list.lua`: Registers autocommands, `:BufferList` user command, initializes the plugin, and binds the tabline renderer.





## Development

### Run tests

Running tests requires `luarocks` or `busted` and `nlua`.

```bash
PATH=$PATH:~/.luarocks/bin:~/.local/bin luarocks test --local
```

### Run linter & formatter checks

```bash
PATH=$PATH:~/.luarocks/bin:~/.local/bin luacheck lua plugin tests
PATH=$PATH:~/.luarocks/bin:~/.local/bin stylua --check lua plugin tests
```
