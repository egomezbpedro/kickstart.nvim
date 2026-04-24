-- Git related plugins
return {
  'tpope/vim-fugitive',
  config = function()
    -- Working with the stagging area
    vim.keymap.set('n', '<leader>gg', '<cmd>Git<CR>', { desc = 'Git Status' })
    vim.keymap.set('n', '<leader>ga', '<cmd>Git add %<cr>', { desc = 'Stage the current file' })

    -- Working with a repo
    vim.keymap.set('n', '<leader>grb', '<cmd>Git branch<CR>', { desc = 'Git Log' })

    -- Git log
    vim.keymap.set('n', '<leader>glo', '<cmd>Git log<CR>', { desc = 'Git Log' })
    vim.keymap.set('n', '<leader>gla', '<cmd>Git log --oneline --decorate --graph --all<CR>', { desc = 'Git Log -o -d -g -a' })
    vim.keymap.set('n', '<leader>gcl', '<cmd>Gclog<CR>', { desc = 'Gclog' })

    -- Show git blame for the current file
    vim.keymap.set('n', '<leader>bl', '<cmd>Git blame<cr>', { desc = 'Show the blame' })

    -- Diffs
    vim.keymap.set('n', '<leader>gvs', function()
      local builtin = require 'telescope.builtin'
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      builtin.git_branches {
        prompt_title = 'Select Branch for Gvdiffsplit',
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)

            local selection = action_state.get_selected_entry()

            if selection == nil then
              print 'No branch selected'
              return
            end

            local branch_name = selection.value
            vim.cmd('Gvdiffsplit ' .. branch_name)
          end)

          return true
        end,
      }
    end, { desc = 'Fugitive Diff against a Telescope selected branch' })

    -- Push commits to remote
    vim.keymap.set('n', '<leader>gpp', function() vim.cmd.Git 'push' end, { desc = 'Git Push' })

    -- Pull and rebase from remote
    vim.keymap.set('n', '<leader>gpr', function() vim.cmd.Git { 'pull', '--rebase' } end, { desc = 'Git pull --rebase' })

    -- Push to origin and set upstream (prompts for branch name)
    vim.keymap.set('n', '<leader>gpo', ':Git push -u origin ', { desc = 'Git push origin' })
  end,
}
