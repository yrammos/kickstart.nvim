-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- VARIOUS OPTIONS
-- [[ Python settings ]]
vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '~/mambaforge/envs/nvim/bin/python'

-- Auto-save in swap
vim.g.updatecount = 100

-- Display relative numbers
vim.wo.relativenumber = true

-- Highlight current line
vim.opt.cursorline = true

-- Soft wrapping settings
vim.o.linebreak = true

-- Scrolling context
vim.o.scrolloff = 1
vim.o.sidescrolloff = 3

-- KEYMAPS
-- Switch from insert to normal mode using jk and kj
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('i', 'kj', '<Esc>', { noremap = true })

-- Move cursor by display lines
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

-- Cure register insanity
vim.keymap.set('n', 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })
vim.keymap.set('n', 'c', '"_c', { noremap = true })
vim.keymap.set('n', 'x', '"_x', { noremap = true })
vim.keymap.set('n', 'X', '"_X', { noremap = true })

-- Buffer switching
vim.keymap.set('n', '<C-n>', '<cmd>bnext<CR>', { silent = true })
vim.keymap.set('n', '<C-p>', '<cmd>bprev<CR>', { silent = true })

-- Telescope
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })

return {}
