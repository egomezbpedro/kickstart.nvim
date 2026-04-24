return {
  dir = '~/projects/jira.nvim/',
  name = 'jira.nvim',
  opts = {
    jira = {
      version = 3,
      limit = 50,
    },
    projects = { 'rcpopd', 'psm' },
  },
  keys = {
    { '<leader>jj', function() vim.cmd 'Jira' end, desc = 'Jira: board' },
    { '<leader>jf', function() require('jira.telescope').search 'rcpodp' end, desc = 'Jira: search (JQL)' },
    { '<leader>jm', function() require('jira.telescope').my_tasks() end, desc = 'Jira: my tasks' },
    { '<leader>js', function() require('jira.telescope').sprint 'rcpopd' end, desc = 'Jira: sprint' },
    {
      '<leader>ji',
      function()
        local key = vim.fn.expand('<cword>'):upper()
        if key:match '^%u+%-%d+$' then
          require('jira.issue').open(key)
        else
          vim.ui.input({ prompt = 'Issue key: ' }, function(k)
            if k and k ~= '' then require('jira.issue').open(k:upper()) end
          end)
        end
      end,
      desc = 'Jira: open issue',
    },
    {
      '<leader>je',
      function()
        local key = vim.fn.expand('<cword>'):upper()
        if key:match '^%u+%-%d+$' then
          require('jira.edit').open(key)
        else
          vim.ui.input({ prompt = 'Issue key: ' }, function(k)
            if k and k ~= '' then require('jira.edit').open(k:upper()) end
          end)
        end
      end,
      desc = 'Jira: edit issue',
    },
    -- { '<leader>jc', function() vim.cmd 'Jira create rcpopd' end, desc = 'Jira: create issue' },
    -- { '<leader>jal', function() vim.cmd 'Jira auth login' end, desc = 'Jira: login' },
    { '<leader>jai', function() vim.cmd 'Jira auth info' end, desc = 'Jira: auth info' },
  },
}
