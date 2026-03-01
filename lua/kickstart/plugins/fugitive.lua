-- Git related plugins
return {
  'tpope/vim-fugitive',
  config = function()
    -- Open Git status in a vertical split
    vim.keymap.set('n', '<leader>g', '<cmd>vertical Git<CR>', { desc = 'Git Status' })

    -- Open Git log in a vertical split
    vim.keymap.set('n', '<leader>gl', '<cmd>vertical Git log<CR>', { desc = 'Git Log' })
    -- Open Git log with compact graph view in a vertical split
    vim.keymap.set('n', '<leader>glo', '<cmd>vertical Git log --oneline --decorate --graph<CR>', { desc = 'Git Log -o -d -g' })

    -- Stage the current file
    vim.keymap.set('n', '<leader>ga', '<cmd>Git add %<cr>', { desc = 'Stage the current file' })
    -- Show git blame for the current file
    vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>', { desc = 'Show the blame' })

    -- Push commits to remote
    vim.keymap.set('n', '<leader>gpp', function() vim.cmd.Git 'push' end, { desc = 'Git Push' })

    -- Pull and rebase from remote
    vim.keymap.set('n', '<leader>gpr', function() vim.cmd.Git { 'pull', '--rebase' } end, { desc = 'Git pull --rebase' })

    -- Push to origin and set upstream (prompts for branch name)
    vim.keymap.set('n', '<leader>gpo', ':Git push -u origin ', { desc = 'Git push origin' })
  end,
}
