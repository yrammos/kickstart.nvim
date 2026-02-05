return {
  'olimorris/codecompanion.nvim',
  enabled = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    send_code = false,
    interactions = {
      chat = {
        adapter = 'copilot',
      },
      inline = {
        adapter = 'copilot',
      },
      cmd = {
        adapter = 'copilot',
      },
    },
  },
  keys = {
    { '<leader>ca', '<cmd>CodeCompanionActions<cr>', { 'n', 'v' }, desc = '[C]odeCompanion [A]ctions' },
    { '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { 'n', 'v' }, desc = '[C]odeCompanion [Chat]' },
    { '<leader>cd', '<cmd>CodeCompanionChat Add<cr>', { 'v' }, desc = '[C]odeCompanion A[D]d' },
  },
}
