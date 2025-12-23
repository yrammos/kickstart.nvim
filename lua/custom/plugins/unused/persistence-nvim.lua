return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  opts = {
    dir = vim.fn.stdpath 'state' .. '/sessions/', -- directory where session files are saved
    -- minimum number of file buffers that need to be open to save
    -- Set to 0 to always save
    need = 1,
    branch = true, -- use git branch to save session
  },
  keys = {
    { '<leader><C-s>l', '<cmd>lua require("persistence").load()<cr>', { 'n' }, desc = '[S]ession: [l]oad for current directory' },
    { '<leader><C-s>L', '<cmd>lua require("persistence").select()<cr>', { 'n' }, desc = '[S]ession: [Loader] dialog' },
    { '<leader><C-s>D', '<cmd>lua require("persistence").load( {last = true} )<cr>', { 'n' }, desc = '[S]ession: loa[D] last' },
    { '<leader><C-s>n', '<cmd>lua require("persistence").stop()<cr>', { 'n' }, desc = '[S]ession: do [n]ot save on exit' },
  },
}
