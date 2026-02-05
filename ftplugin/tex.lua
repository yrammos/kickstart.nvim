local function set_engine_arg_to(arg)
  local texlab_client = vim.lsp.get_clients({ name = 'texlab' })[1]
  if texlab_client and texlab_client.config.settings.texlab.build.args then
    texlab_client.config.settings.texlab.build.args[4] = arg
    texlab_client.notify('workspace/didChangeConfiguration', {
      settings = texlab_client.config.settings,
    })
    print('TeXlab engine set to `' .. arg .. '`.')
  else
    print 'Unable to find active TeXlab LSP client.'
  end
end

vim.api.nvim_buf_create_user_command(0, 'TexlabPDFLaTeX', function()
  set_engine_arg_to '-pdf'
end, { desc = 'Set engine to pdfLaTeX' })

vim.api.nvim_buf_create_user_command(0, 'TexlabXeLaTeX', function()
  set_engine_arg_to '-xelatex'
end, { desc = 'Set engine to XeLaTeX' })

local map = require('utils.keymap').buf_map(true, 'TeXLab: ')

map('<localleader>ll', '<cmd>LspTexlabBuild<cr>', 'Bui[l]d')
map('<localleader>lk', '<cmd>LspTexlabCancelBuild<cr>', 'Cancel Build')
map('<localleader>lv', '<cmd>LspTexlabForward<cr>', 'Forward Search')
map('<localleader>la', '<cmd>LspTexlabCleanAuxiliary<cr>', 'Clean Aux')
map('<localleader>lA', '<cmd>LspTexlabCleanArtifacts<cr>', 'Clean Artifacts')
map('<localleader>le', '<cmd>LspTexlabChangeEnvironment<cr>', 'Change Env')
map('<localleader>lf', '<cmd>LspTexlabFindEnvironments<cr>', 'Find Env')
