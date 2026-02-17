-- Conform (formatters).
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable `format_on_save lsp_fallback` for selected languages.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters = {
      latexindent = {
        prepend_args = { '-m', '-l=' .. vim.fn.expand '~/.latexindent.yaml' .. ',.latexindent.yaml' },
      },
    },
    formatters_by_ft = {
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" }.
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true }.
      angular = { 'prettierd' },
      bibtex = { 'latexindent' },
      context = { 'latexindent' },
      css = { 'prettierd' },
      flow = { 'prettierd' },
      graphql = { 'prettierd' },
      html = { 'prettierd' },
      javascript = { 'eslint_d' },
      json = { 'prettierd' },
      jsx = { 'prettierd' },
      latex = { 'latexindent' },
      less = { 'prettierd' },
      lua = { 'stylua' },
      markdown = { 'prettierd' },
      plaintex = { 'latexindent' },
      python = { 'ruff_format' },
      scss = { 'prettierd' },
      tex = { 'latexindent' },
      typescript = { 'prettierd' },
      vue = { 'prettierd' },
      xml = { 'xmlformat' },
      yaml = { 'prettierd' },
    },
  },
}
