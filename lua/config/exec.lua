local path_config = function()
  local filepath = vim.fn.expand '%:p'
  -- Construct the tmux command
  local args = vim.fn.input 'Enter script arguments: '

  return filepath, args
end

-- Send shell script
vim.keymap.set('n', '<space>sh', function()
  local filepath, args = path_config()

  vim.fn.system(string.format('tmux new-window \'bash -E -c "%s %s & while [ : ]; do sleep 1; done"\'', filepath, args))
end)

-- Send Python script
vim.keymap.set('n', '<space>py', function()
  local filepath, args = path_config()
  vim.fn.system(string.format('tmux new-window \'bash -E -c "python3 %s %s & while [ : ]; do sleep 1; done"\'', filepath, args))
end)
