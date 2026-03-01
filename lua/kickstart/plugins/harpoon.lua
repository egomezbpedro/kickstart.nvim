return {
  'ThePrimeagen/harpoon',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = true,
  keys = {
    { '<leader>a', "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = 'Mark file with harpoon' },

    { '<leader>1', "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = 'Go to 1' },
    { '<leader>2', "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = 'Go to 2' },
    { '<leader>3', "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = 'Go to 3' },
    { '<leader>4', "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = 'Go to 4' },

    { '<C-e>', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = 'Show harpoon marks' },
  },
}
