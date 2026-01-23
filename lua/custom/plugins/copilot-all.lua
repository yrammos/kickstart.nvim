return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = false,
        tex = false,
        text = false,
        gitcommit = false,
        help = false,
        ['.'] = false,
        ['*'] = true,
      },
      should_attach = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        local exclude = { 'markdown', 'latex', 'tex', 'plaintex', 'text', 'typst', 'help', 'org', 'taskpaper', 'norg', 'quarto', 'rmd', 'bib' }
        if vim.tbl_contains(exclude, ft) then
          return false
        end
        return true
      end,
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    'giuxtaposition/blink-cmp-copilot',
  },
}
