return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    rename = { enabled = true },
  },
  keys = {
    { 'grR', function() Snacks.rename.rename_file() end, desc = 'LSP: [R]ename File' },
  },
}
