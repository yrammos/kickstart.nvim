-- TeXlab extensions
local function set_engine_arg_to(arg)
  local texlab_client = vim.lsp.get_clients { name = 'texlab' }
  if texlab_client[1] then
    texlab_client[1].config.settings.texlab.build.args[4] = arg
    vim.lsp.buf_notify(0, 'workspace/didChangeConfiguration', { settings = texlab_client[1].config.settings })
    print('TeXlab engine argument set to `' .. arg .. '`.')
  else
    print 'Unable to find active TeXlab LSP client.'
  end
end

vim.api.nvim_create_user_command('TexlabPDFLaTeX', function()
  set_engine_arg_to '-pdf'
end, {})

vim.api.nvim_create_user_command('TexlabXeLaTeX', function()
  set_engine_arg_to '-xelatex'
end, {})

vim.api.nvim_create_user_command('TexlabEngineStatus', function()
  local texlab_client = vim.lsp.get_clients { name = 'texlab' }
  if texlab_client[1] then
    local arg = texlab_client[1].config.settings.texlab.build.args[4]
    print('TeXlab engine argument is set to `' .. arg .. '`.')
  else
    print 'Unable to find active TeXlab LSP client.'
  end
end, {})

return {}
