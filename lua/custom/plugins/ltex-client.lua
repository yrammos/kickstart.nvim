return {
  'icewind/ltex-client.nvim',
  config = function()
    require('ltex-client').setup {
      user_dictionaries_path = vim.env.HOME .. '/.local/share/nvim/',
    }
  end,
}
