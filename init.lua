-- NOTE: PRELIMINARIES AND BASIC EDITOR SETTINGS

-- Set <space> as the leader key.
-- Must be in effect before any plugins are loaded.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal.
vim.g.have_nerd_font = true

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode.
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line.
vim.o.showmode = false

-- Autosave in swap.
vim.g.updatecount = 100

-- Highlight current line.
vim.opt.cursorline = true

-- Soft wrapping settings.
vim.o.linebreak = true

-- Scrolling context.
vim.o.scrolloff = 1
vim.o.sidescrolloff = 3

-- Relying on blink.cmp for autocompletion on the command line.
vim.opt.wildmenu = false

-- Sync clipboard between OS and Neovim.
-- Defer the setting to the end of init.lua parsing because it can increase startup-time.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent.
vim.o.breakindent = true

-- Save undo history.
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default.
vim.o.signcolumn = 'yes'

-- Decrease update time.
vim.o.updatetime = 250

-- Decrease mapped sequence wait time.
vim.o.timeoutlen = 300

-- Configure how new splits should be opened.
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions within buffer.
vim.o.inccommand = 'nosplit'

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 999

-- Ask for confirmation before closing dirty buffers.
vim.o.confirm = true

-- Set LSP logging level.
vim.lsp.set_log_level 'warn'

-- Automatically reload files changed outside of Neovim.
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('auto-reload-files', { clear = true }),
  command = 'if mode() != "c" | checktime | endif',
})

-- Delete LSP log if older than 24 hours.
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local log = vim.fn.stdpath 'state' .. '/lsp.log'
    local stat = vim.uv.fs_stat(log)
    if stat and (os.time() - stat.mtime.sec) > 86400 then
      os.remove(log)
      vim.notify('Deleted stale LSP log', vim.log.levels.INFO)
    end
  end,
})

-- NOTE: BASIC KEYMAPS.

-- Clear highlights on search when pressing <Esc> in normal mode.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics quickfix keymap.
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Disable arrow keys in normal mode.
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!"<CR>')

--  Use CTRL+<hjkl> to switch between windows.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight text when yanking.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- NOTE: LAZY & PLUGINS.

-- Install lazy.nvim.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({ -- NOTE: Lazy specs.

  -- Detect tabstop and shiftwidth automatically.
  'NMAC427/guess-indent.nvim',

  { -- Show available keymaps.
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      -- This setting is independent of vim.o.timeoutlen.
      delay = 0,
      icons = {
        -- Set icon mappings to true if you have a Nerd Font.
        mappings = vim.g.have_nerd_font,
        -- Use Nerd Font icons if available, or fallbacks otherwise.
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      -- Document key chains defined by various plugins.
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>a', group = '[A]I' },
      },
    },
  },

  { -- Telescope.
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      -- Replace the default vim.ui.select() with telescope.
      { 'nvim-telescope/telescope-ui-select.nvim' },
      -- Use pretty icons if a Nerd font is available.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      { 'folke/trouble.nvim' },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<C-t>'] = 'trouble',
            ['<C-enter>'] = 'to_fuzzy_refine',
          },
          n = {
            ['<C-t>'] = 'trouble',
          },
        },
      },
      pickers = {
        colorscheme = {
          enable_preview = true,
        },
      },
      extensions = {
        ['ui-select'] = {
          theme = 'dropdown',
        },
        ['file_browser'] = {
          theme = 'ivy',
          hijack_netrw = true,
        },
      },
    },
    config = function()
      -- Protect-call Telescope extensions (if they are installed).
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'file_browser')
      -- Telescope keymaps.
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', require('telescope.builtin').oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sb', function()
        require('telescope').extensions.file_browser.file_browser()
      end, { desc = '[S]earch with [B]rowser' })
      vim.keymap.set('n', '<leader>/', function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>s/', function()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  { -- Extended lua_lsp settings for neovim development.
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  { -- LSP configuration facilities.
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
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

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
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'Op[E]n diagnostics float' }),
      }

      -- nvim-lspconfig: append blink.cmp capabilities.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- nvim-lspconfig: configure servers.
      local servers = {
        cssls = {},
        eslint = {},
        jsonls = {},
        lemminx = {},
        ltex_plus = {
          on_attach = function(_, bufnr)
            require('ltex-utils').on_attach(bufnr)
          end,
          settings = {
            -- See https://ltex-plus.github.io/ltex-plus/settings.html
            ltex = {
              language = 'en-US',
              configurationTarget = {
                dictionary = 'userExternalFile',
                disabledRules = 'userExternalFile',
                hiddenFalsePositives = 'userExternalFile',
              },
              trace = { server = 'off' },
            },
          },
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
              bibtexFormatter = 'texlab',
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
              latexFormatter = 'texlab',
              chktex = {
                onOpenAndSave = true,
                onEdit = true,
              },
            },
          },
        },
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
  },

  { -- Conform (formatters).
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
      formatters_by_ft = {
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" }.
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true }.
        angular = { 'prettierd' },
        context = { 'tex-fmt' },
        css = { 'prettierd' },
        flow = { 'prettierd' },
        graphql = { 'prettierd' },
        html = { 'prettierd' },
        javascript = { 'eslint_d' },
        json = { 'prettierd' },
        jsx = { 'prettierd' },
        latex = { 'tex-fmt' },
        less = { 'prettierd' },
        lua = { 'stylua' },
        markdown = { 'prettierd' },
        plaintex = { 'tex-fmt' },
        python = { 'ruff_format' },
        scss = { 'prettierd' },
        tex = { 'tex-fmt' },
        typescript = { 'prettierd' },
        vue = { 'prettierd' },
        xml = { 'xmlformat' },
        yaml = { 'prettierd' },
      },
    },
  },

  { -- Blink.cmp (auto-completion).
    'saghen/blink.cmp',
    event = 'VimEnter',
    build = 'cargo +nightly build --release',
    version = '1.*',
    dependencies = {
      {
        -- Snippet Engine
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      cmdline = {
        keymap = { preset = 'inherit' },
        completion = { menu = { auto_show = true } },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = 'single' } },
        menu = { border = 'single', draw = {
          columns = { { 'kind_icon', gap = 2, 'label' }, { 'label_description', 'kind' } },
        } },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'copilot' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          copilot = { name = 'copilot', module = 'blink-cmp-copilot', score_offset = 100, async = true },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true, window = { border = 'single' } },
    },
  },

  { -- Highlight todo, notes, etc. in comments.
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  { -- mini.nvim (collection of various small independent plugins/modules).
    'echasnovski/mini.nvim',
    config = function()
      -- a/i text objects.
      require('mini.ai').setup { n_lines = 500 }
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup()
      require('mini.icons').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = true }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
      -- Starter screen.
      local starterscreen = require 'mini.starter'
      starterscreen.setup {
        evaluate_single = true,
        header = '',
        footer = '',
        items = {
          starterscreen.sections.builtin_actions(),
          starterscreen.sections.recent_files(10, false),
          starterscreen.sections.recent_files(10, true),
          starterscreen.sections.telescope(),
          -- Use this if you set up 'mini.sessions'
          -- starterscreen.sections.sessions(5, true),
        },
        content_hooks = {
          starterscreen.gen_hook.adding_bullet(),
          starterscreen.gen_hook.aligning('center', 'center'),
          starterscreen.gen_hook.indexing('all', { 'Builtin actions' }),
          starterscreen.gen_hook.padding(3, 2),
        },
      }
      -- Diff view for buffers.
      require('mini.diff').setup()
    end,
  },

  { -- Treesitter.
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      modules = {},
      sync_install = false,
      ignore_install = {},
    },
  },

  -- NOTE: IMPORT SPECS FROM OTHER FILES.
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  { import = 'custom.plugins' },
}, { -- NOTE: Lazy config continued.
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
