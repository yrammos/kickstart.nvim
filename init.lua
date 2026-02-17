-- NOTE: PRELIMINARIES AND BASIC EDITOR SETTINGS

-- Set <space> as the leader key.
-- Must be in effect before any plugins are loaded.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal.
vim.g.have_nerd_font = true

-- Python settings.
vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '$HOME/.micromamba/envs/neovim/bin/python'

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode.
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line.
vim.o.showmode = false

-- Hide the command line area (messages appear as floating windows).
vim.o.cmdheight = 0

-- Autosave in swap.
vim.g.updatecount = 100

-- Highlight current line.
vim.opt.cursorline = true

-- Soft wrapping settings.
vim.o.linebreak = true

-- Scrolling context.
vim.o.scrolloff = 999
vim.o.sidescrolloff = 3

-- Relying on blink.cmp for autocompletion on the command line.
vim.opt.wildmenu = false

-- Sync clipboard between OS and Neovim.
-- Defer the setting to the end of init.lua parsing because it can increase startup-time.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent.
vim.o.breakindent = true

-- Save undo history.
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default.
vim.o.signcolumn = 'yes'

-- Decrease update time.
vim.o.updatetime = 250

-- Decrease mapped sequence wait time.
vim.o.timeoutlen = 300

-- Configure how new splits should be opened.
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions within buffer.
vim.o.inccommand = 'nosplit'

-- Ask for confirmation before closing dirty buffers.
vim.o.confirm = true

-- Set LSP logging level.
vim.lsp.set_log_level 'warn'

-- Automatically reload files changed outside of Neovim.
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('auto-reload-files', { clear = true }),
  command = 'if mode() != "c" && getcmdwintype() == "" | checktime | endif',
})

-- Delete LSP log if older than 24 hours (cross-platform).
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local state_dir = vim.fn.stdpath 'state'
    local log = state_dir .. '/lsp.log'
    local marker = state_dir .. '/lsp.log.cleared'

    if not vim.uv.fs_stat(log) then
      return
    end

    local marker_stat = vim.uv.fs_stat(marker)
    local last_cleared = marker_stat and marker_stat.mtime.sec or 0

    if (os.time() - last_cleared) > 86400 then
      os.remove(log)
      io.open(marker, 'w'):close()
      vim.notify('Deleted stale LSP log', vim.log.levels.INFO)
    end
  end,
})

-- NOTE: BASIC KEYMAPS.

-- Clear highlights on search when pressing <Esc> in normal mode.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics quickfix keymap.
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Disable arrow keys in normal mode.
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!"<CR>')

-- Switch from insert to normal mode using jk and kj.
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('i', 'kj', '<Esc>', { noremap = true })

-- Move cursor by display lines.
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

-- Cure register insanity.
vim.keymap.set('n', 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })
vim.keymap.set('n', 'c', '"_c', { noremap = true })
vim.keymap.set('n', 'x', '"_x', { noremap = true })
vim.keymap.set('n', 'X', '"_X', { noremap = true })

-- Buffer switching.
vim.keymap.set('n', '<C-n>', '<cmd>bnext<CR>', { silent = true })
vim.keymap.set('n', '<C-p>', '<cmd>bprev<CR>', { silent = true })

--  Use CTRL+<hjkl> to switch between windows.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight text when yanking.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- NOTE: LAZY & PLUGINS.

-- Install lazy.nvim.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
