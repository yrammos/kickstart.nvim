return {
  'icewind/ltex-client.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    user_dictionaries_path = vim.env.HOME .. '/.local/share/nvim/',
  },
}
