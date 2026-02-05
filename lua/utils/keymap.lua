-- Keymap utility functions.
local M = {}

--- Create a buffer-local keymap helper with optional description prefix.
---@param bufnr number|boolean Buffer number or true for current buffer
---@param prefix string|nil Optional prefix for descriptions (e.g., 'LSP: ')
---@return function map(keys, func, desc, mode?)
function M.buf_map(bufnr, prefix)
  prefix = prefix or ''
  return function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, {
      buffer = bufnr,
      silent = true,
      desc = prefix .. desc,
    })
  end
end

return M
