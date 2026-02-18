-- mini.nvim (collection of various small independent plugins/modules).
return {
  'echasnovski/mini.nvim',
  config = function()
    -- a/i text objects.
    require('mini.ai').setup { n_lines = 500 }
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
    -- Diff view for buffers.
    require('mini.diff').setup()
  end,
}
