-- LSP configuration facilities.
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Extra capabilities are provided by blink.cmp.
    'saghen/blink.cmp',
  },

  config = function()
    -- nvim-lspconfig: LspAttach() config.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = require('utils.keymap').buf_map(event.buf, 'LSP: ')

        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('grr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
        map('gri', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
        map('grd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gO', function() Snacks.picker.lsp_symbols() end, 'Open Document Symbols')
        map('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
        map('grt', function() Snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')

        -- LspAttach(): Highlight references of the word under the cursor.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- LspAttach: Keymap for toggling inlay hints, if supported by the server.
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- nvim-lspconfig: diagnostic API config.
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
    }

    -- nvm-lspconfig: diagnostics keymap.
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'Op[E]n diagnostics float' })

    -- nvim-lspconfig: append blink.cmp capabilities.
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- nvim-lspconfig: configure servers.
    local servers = {
      cssls = {},
      eslint = {},
      html = {},
      jsonls = {},
      lemminx = {},
      ltex_plus = {
        on_attach = function()
          require('ltex_ls_plus_ui').on_attach()
        end,
        settings = require('ltex_ls_plus_ui').settings(),
        filetypes = { 'bibtex', 'context', 'context.tex', 'latex', 'markdown', 'mdx', 'org', 'restructuredtext', 'rsweave', 'tex' },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            diagnostics = { globals = { 'vim' }, disable = { 'missing-fields' } },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
          },
        },
      },
      marksman = {},
      ruff = {},
      texlab = {
        settings = {
          texlab = {
            build = {
              executable = 'latexmk',
              args = { '-p', '-outdir=out', '-synctex=1', '-xelatex', '%f' },
              forwardSearchAfter = true,
              onSave = true,
              auxDirectory = './out',
              logDirectory = './out',
              pdfDirectory = './out',
            },
            forwardSearch = {
              executable = '/Applications/Skim.app/Contents/SharedSupport/displayline',
              args = { '-background', '-readingbar', '%l', '%p', '%f' },
            },
            formatterLineLength = 0,
            experimental = {
              citationCommands = { 'autocite' },
              labelDefinitionCommands = {},
              labelReferenceCommands = {},
            },
            latexFormatter = 'latexindent',
            chktex = {
              onOpenAndSave = true,
              onEdit = true,
            },
          },
        },
      },
      ts_ls = {},
      ty = {},
      yamlls = {},
    }

    -- nvim-lspconfig: ensure the aforementioned servers and tools are installed.
    local ensure_installed = vim.tbl_keys(servers or {})
    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed, -- The aforementioned servers should be installed via Mason.
    }

    -- nvim-lspconfig: enable servers.
    require('mason-lspconfig').setup {
      automatic_enable = ensure_installed, -- Only auto-enable the aforementioned servers.
    }
    for server_name, server_config in pairs(servers) do
      server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
      vim.lsp.config(server_name, server_config)
      vim.lsp.enable(server_name)
    end
  end,
}
