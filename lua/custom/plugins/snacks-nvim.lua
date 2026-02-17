return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    rename = { enabled = true },
    picker = {
      enabled = true,
      ui_select = true,
      actions = {
        trouble_open = function(picker)
          require('trouble.sources.snacks').open(picker)
        end,
      },
      win = {
        input = {
          keys = {
            ['<c-t>'] = { 'trouble_open', mode = { 'n', 'i' }, desc = 'Open in Trouble' },
          },
        },
        list = {
          keys = {
            ['<c-t>'] = { 'trouble_open', mode = { 'n' }, desc = 'Open in Trouble' },
          },
        },
      },
      layout = {
        preset = 'vertical',
      },
    },
  },
  keys = {
    { 'grR', function() Snacks.rename.rename_file() end, desc = 'LSP: [R]ename File' },
    -- Search keymaps
    { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
    { '<leader>sf', function() Snacks.picker.files() end, desc = '[S]earch [F]iles' },
    { '<leader>ss', function() Snacks.picker.pickers() end, desc = '[S]earch [S]elect Picker' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch current [W]ord' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
    { '<leader>s.', function() Snacks.picker.recent() end, desc = '[S]earch Recent Files' },
    { '<leader><leader>', function() Snacks.picker.buffers() end, desc = '[ ] Find existing buffers' },
    { '<leader>sb', function() Snacks.picker.explorer() end, desc = '[S]earch with [B]rowser' },
    { '<leader>/', function() Snacks.picker.lines({ layout = { preset = 'dropdown', preview = false } }) end, desc = '[/] Fuzzily search in current buffer' },
    { '<leader>s/', function() Snacks.picker.grep({ buffers = true }) end, desc = '[S]earch [/] in Open Files' },
    { '<leader>sn', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = '[S]earch [N]eovim files' },
  },
}
