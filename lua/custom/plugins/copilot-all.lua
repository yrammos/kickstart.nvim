return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    opts = function()
      local excluded_filetypes = {
        'bib',
        'conf',
        'dosini',
        'gitcommit',
        'gitrebase',
        'help',
        'latex',
        'markdown',
        'norg',
        'org',
        'plaintex',
        'quarto',
        'rmd',
        'taskpaper',
        'tex',
        'text',
        'typst',
      }

      local sensitive_filename_and_path_patterns = {
        '%.env$',
        '%.env%.',
        '%.envrc$',
        '/%.aws/',
        '/%.docker/config%.json$',
        '/%.gnupg/',
        '/%.netrc$',
        '/%.ssh/',
        '/secrets/',
        'credentials',
        'password',
      }

      local function is_sensitive_path(filepath)
        local path = filepath:lower()
        for _, pattern in ipairs(sensitive_filename_and_path_patterns) do
          if path:find(pattern) then
            return true
          end
        end
        return false
      end

      local function should_exclude(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == '' or vim.tbl_contains(excluded_filetypes, ft) then
          return true
        end
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if is_sensitive_path(filepath) then
          return true
        end
        return false
      end

      -- Detach/attach Copilot when filetype changes
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('CopilotFiletypeToggle', { clear = true }),
        callback = function(args)
          local clients = vim.lsp.get_clients { bufnr = args.buf, name = 'copilot' }
          if should_exclude(args.buf) then
            for _, client in ipairs(clients) do
              vim.lsp.buf_detach_client(args.buf, client.id)
            end
          elseif #clients > 0 then
            -- Copilot is running but not attached to this buffer - attach it
            for _, client in ipairs(clients) do
              if not vim.lsp.buf_is_attached(args.buf, client.id) then
                vim.lsp.buf_attach_client(args.buf, client.id)
              end
            end
          else
            -- Copilot not running yet - start it via copilot.lua
            local ok, copilot = pcall(require, 'copilot.client')
            if ok and copilot.buf_attach then
              copilot.buf_attach()
            end
          end
        end,
      })

      return {
        suggestion = { enabled = false },
        panel = { enabled = false },
        should_attach = function(bufnr)
          return not should_exclude(bufnr)
        end,
      }
    end,
  },
  {
    'giuxtaposition/blink-cmp-copilot',
  },
}
