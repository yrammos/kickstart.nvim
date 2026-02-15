-- Minimal replacement for ltex-utils.nvim.
--
-- Handles _ltex.addToDictionary, _ltex.hideFalsePositives, and
-- _ltex.disableRules code actions. Persists entries to text files in
-- stdpath('state')/ltex/ and sends properly formatted
-- didChangeConfiguration notifications.

local M = {}

local dir = vim.fn.stdpath('state') .. '/ltex/'

local function read_lines(path)
  local f = io.open(path, 'r')
  if not f then return {} end
  local lines = {}
  for line in f:lines() do
    if line ~= '' then lines[#lines + 1] = line end
  end
  f:close()
  return lines
end

local function append_lines(path, lines)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')
  local f = io.open(path, 'a')
  if f then
    for _, line in ipairs(lines) do
      f:write(line .. '\n')
    end
    f:close()
  end
end

local function get_client()
  return vim.lsp.get_clients({ name = 'ltex_plus' })[1]
end

local function notify_change(client)
  client:notify('workspace/didChangeConfiguration', { settings = client.settings })
end

--- Build initial ltex settings by scanning existing files.
--- All entries are loaded into memory so the server sees them via
--- workspace/configuration responses.
function M.settings()
  local dictionary = {}
  local hiddenFalsePositives = {}
  local disabledRules = {}

  for _, path in ipairs(vim.fn.glob(dir .. '*.txt', false, true)) do
    local name = vim.fn.fnamemodify(path, ':t:r')
    local fp_lang = name:match('^hiddenFalsePositives%.(.+)$')
    local rule_lang = name:match('^disabledRules%.(.+)$')
    if fp_lang then
      hiddenFalsePositives[fp_lang] = read_lines(path)
    elseif rule_lang then
      disabledRules[rule_lang] = read_lines(path)
    else
      dictionary[name] = read_lines(path)
    end
  end

  return {
    ltex = {
      language = 'en-US',
      dictionary = next(dictionary) and dictionary or nil,
      hiddenFalsePositives = next(hiddenFalsePositives) and hiddenFalsePositives or nil,
      disabledRules = next(disabledRules) and disabledRules or nil,
      configurationTarget = {
        dictionary = 'userExternalFile',
        disabledRules = 'userExternalFile',
        hiddenFalsePositives = 'userExternalFile',
      },
    },
  }
end

--- Register code action handlers in vim.lsp.commands.
function M.on_attach()
  vim.lsp.commands['_ltex.addToDictionary'] = function(cmd)
    local cl = get_client()
    if not cl then return end
    local setting = cl.settings.ltex.dictionary or {}
    for lang, words in pairs(cmd.arguments[1].words) do
      append_lines(dir .. lang .. '.txt', words)
      setting[lang] = setting[lang] or {}
      vim.list_extend(setting[lang], words)
    end
    cl.settings.ltex.dictionary = setting
    notify_change(cl)
  end

  vim.lsp.commands['_ltex.hideFalsePositives'] = function(cmd)
    local cl = get_client()
    if not cl then return end
    local setting = cl.settings.ltex.hiddenFalsePositives or {}
    for lang, entries in pairs(cmd.arguments[1].falsePositives) do
      append_lines(dir .. 'hiddenFalsePositives.' .. lang .. '.txt', entries)
      setting[lang] = setting[lang] or {}
      vim.list_extend(setting[lang], entries)
    end
    cl.settings.ltex.hiddenFalsePositives = setting
    notify_change(cl)
  end

  vim.lsp.commands['_ltex.disableRules'] = function(cmd)
    local cl = get_client()
    if not cl then return end
    local setting = cl.settings.ltex.disabledRules or {}
    for lang, rules in pairs(cmd.arguments[1].ruleIds) do
      append_lines(dir .. 'disabledRules.' .. lang .. '.txt', rules)
      setting[lang] = setting[lang] or {}
      vim.list_extend(setting[lang], rules)
    end
    cl.settings.ltex.disabledRules = setting
    notify_change(cl)
  end
end

-- Register as a requireable module. This file lives in custom/plugins/
-- which lazy.nvim scans for plugin specs, so we return {} as a valid
-- empty spec and expose the module via package.loaded instead.
package.loaded['ltex_ls_plus_ui'] = M
return {}
