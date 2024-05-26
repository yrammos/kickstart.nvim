vim.g.matrix_contrast = true
vim.g.matrix_borders = false
vim.g.matrix_disable_background = false
vim.g.matrix_italic = false

return {
  'iruzo/matrix-nvim',
  config = function()
    vim.cmd.colorscheme 'matrix'
  end,
}
