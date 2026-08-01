local M = {}

--- OS file separator
M.SEP = package.config:sub(1, 1)

M.hl_active_item = "%#TabLineSel#"
M.hl_inactive_item = "%#TabLineFill#"
M.hl_autofill = "%#NONE#"

return M
