-- Blink.cmp (auto-completion).
return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  build = 'cargo +nightly build --release',
  version = '1.*',
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
    snippets = { preset = 'default' },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true, window = { border = 'single' } },
  },
}
