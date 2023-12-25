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

-- Trouble
vim.keymap.set('n', '<leader>xx', function()
  require('trouble').toggle()
end, { desc = 'Toggle Trouble' })
vim.keymap.set('n', '<leader>xw', function()
  require('trouble').toggle 'workspace_diagnostics'
end, { desc = 'Toggle [W]orkspace diagnostics in Trouble' })
vim.keymap.set('n', '<leader>xd', function()
  require('trouble').toggle 'document_diagnostics'
end, { desc = 'Toggle [D]ocument diagnostics in Trouble' })
vim.keymap.set('n', '<leader>xq', function()
  require('trouble').toggle 'quickfix'
end, { desc = 'Toggle [Q]uickfix in Trouble' })
vim.keymap.set('n', '<leader>xl', function()
  require('trouble').toggle 'loclist'
end, { desc = 'Toggle [L]ocation list in Trouble' })
vim.keymap.set('n', 'gR', function()
  require('trouble').toggle 'lsp_references'
end, { desc = 'Toggle LSP [R]eferences in Trouble' })

-- TeXlab extensions
local function set_engine_arg_to(arg)
  local texlab_client = vim.lsp.get_clients { name = 'texlab' }
  if texlab_client[1] then
    texlab_client[1].config.settings.texlab.build.args[4] = arg
    vim.lsp.buf_notify(0, 'workspace/didChangeConfiguration', { settings = texlab_client[1].config.settings })
    print('TeXlab engine argument set to `' .. arg .. '`.')
  else
    print 'Unable to find active TeXlab LSP client.'
  end
end

vim.api.nvim_create_user_command('TexlabPDFLaTeX', function()
  set_engine_arg_to '-pdf'
end, {})

vim.api.nvim_create_user_command('TexlabXeLaTeX', function()
  set_engine_arg_to '-xelatex'
end, {})

vim.api.nvim_create_user_command('TexlabEngineStatus', function()
  local texlab_client = vim.lsp.get_clients { name = 'texlab' }
  if texlab_client[1] then
    local arg = texlab_client[1].config.settings.texlab.build.args[4]
    print('TeXlab engine argument is set to `' .. arg .. '`.')
  else
    print 'Unable to find active TeXlab LSP client.'
  end
end, {})

return {}
