return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = true,
  opts = {
    port_range = { min = 10000, max = 65535 },
    auto_start = true,
    log_level = 'warn', -- "trace", "debug", "info", "warn", "error"
    terminal_cmd = '~/.local/bin/claude',
    -- When true, successful sends will focus the Claude terminal if already connected.
    focus_after_send = false,
    -- Selection Tracking.
    track_selection = true,
    visual_demotion_delay_ms = 50,
    -- Terminal Configuration.
    terminal = {
      split_side = 'right',
      split_width_percentage = 0.40,
      provider = 'auto', -- "auto", "snacks", "native", "external", "none", or custom provider table
      auto_close = true,
      snacks_win_opts = {},
      cwd_provider = function(ctx) -- Determines the working directory for Claude Code.
        -- Prefer repo root; fallback to file's directory.
        local cwd = require('claudecode.cwd').git_root(ctx.file_dir or ctx.cwd) or ctx.file_dir or ctx.cwd
        return cwd
      end,
      provider_opts = {
        -- Command for external terminal provider. Can be:
        -- 1. String with %s placeholder: "alacritty -e %s" (backward compatible).
        -- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command).
        -- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end.
        external_terminal_cmd = nil,
      },
    },
    -- Diff Integration
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = true,
      keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens.
    },
  },
  cmd = {
    'ClaudeCode',
    'ClaudeCodeFocus',
    'ClaudeCodeSelectModel',
    'ClaudeCodeAdd',
    'ClaudeCodeSend',
    'ClaudeCodeTreeAdd',
    'ClaudeCodeDiffAccept',
    'ClaudeCodeDiffDeny',
  },
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
