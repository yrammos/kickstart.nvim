return {
  'jesseleite/nvim-noirbuddy',
  dependencies = {
    { 'tjdevries/colorbuddy.nvim' },
  },
  lazy = false,
  priority = 1000,
  opts = {
    -- All of your `setup(opts)` will go here
    preset = 'crt-green',
    -- preset = 'kiwi',
    -- preset = 'miami-nights',
    -- preset = 'minimal',
    -- preset = 'slate',
    -- preset = 'crt-amber',
  },
}
