return {
  -- UI and text color plugins.
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre', 'VeryLazy' },
  },
  {
    'xiyaowong/transparent.nvim',
    lazy = false,
    event = 'VimEnter',
  },
  -- Themes.
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    -- init = function()
    -- vim.cmd.colorscheme 'tokyonight'
    -- ... or 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.

    -- You can configure highlights by doing something like:
    --   vim.cmd.hi 'Comment gui=none'
    -- end,
  },
  { 'EdenEast/nightfox.nvim' },
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      -- vim.g.everforest_enable_italic = true
      -- vim.cmd.colorscheme('everforest')
    end,
  },
  {
    'srcery-colors/srcery-vim',
    config = function()
      -- vim.cmd.colorscheme 'srcery'
    end,
  },
  {
    'slugbyte/lackluster.nvim',
    lazy = false,
    priority = 1000,
    init = function()
      -- vim.cmd.colorscheme 'lackluster'
      -- vim.cmd.colorscheme 'lackluster-hack'
      -- vim.cmd.colorscheme 'lackluster-mint'
    end,
  },
  {
    'iruzo/matrix-nvim',
    config = function()
      -- vim.g.matrix_contrast = true
      -- vim.g.matrix_borders = false
      -- vim.g.matrix_disable_background = false
      -- vim.g.matrix_italic = false
      -- vim.cmd.colorscheme 'matrix'
    end,
  },
  {
    'ramojus/mellifluous.nvim',
    lazy = false,
    priority = 1000,
    init = function()
      -- vim.cmd.colorscheme 'mellifluous'
    end,
  },
  {
    'jesseleite/nvim-noirbuddy',
    dependencies = {
      { 'tjdevries/colorbuddy.nvim' },
    },
    lazy = false,
    priority = 1000,
    opts = {
      preset = 'crt-green',
      -- preset = 'kiwi',
      -- preset = 'miami-nights',
      -- preset = 'minimal',
      -- preset = 'slate',
      -- preset = 'crt-amber',
    },
    install = {
      colorscheme = { 'noirbuddy' },
    },
  },
  {
    'olivercederborg/poimandres.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('poimandres').setup {
        -- leave this setup function empty for default config
        -- or refer to the configuration section
        -- for configuration options
      }
    end,

    -- optionally set the colorscheme within lazy config
    init = function()
      -- vim.cmd.colorscheme 'poimandres'
    end,
  },
  {
    '0xstepit/flow.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
}
