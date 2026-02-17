-- mini.nvim (collection of various small independent plugins/modules).
return {
  'echasnovski/mini.nvim',
  config = function()
    -- a/i text objects.
    require('mini.ai').setup { n_lines = 500 }
    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    require('mini.surround').setup()
    require('mini.icons').setup()
    require('mini.statusline').setup {
      use_icons = true,
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local git = MiniStatusline.section_git { trunc_width = 40 }
          local diff = MiniStatusline.section_diff { trunc_width = 75 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
          local filename = MiniStatusline.section_filename { trunc_width = 140 }
          local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
          local searchcount = MiniStatusline.section_searchcount { trunc_width = 75 }

          local bufnr = '(' .. vim.api.nvim_get_current_buf() .. ')'

          return MiniStatusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            '%<',
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=',
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { searchcount, '%2l:%-2v', bufnr } },
          }
        end,
      },
    }
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
        {
          { action = 'lua Snacks.picker.explorer()',  name = 'Browser',         section = 'Picker' },
          { action = 'lua Snacks.picker.command_history()', name = 'Command history', section = 'Picker' },
          { action = 'lua Snacks.picker.files()',     name = 'Files',           section = 'Picker' },
          { action = 'lua Snacks.picker.help()',      name = 'Help tags',       section = 'Picker' },
          { action = 'lua Snacks.picker.grep()',      name = 'Live grep',       section = 'Picker' },
          { action = 'lua Snacks.picker.recent()',    name = 'Old files',       section = 'Picker' },
        },
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
}
