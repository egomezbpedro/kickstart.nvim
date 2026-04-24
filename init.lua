--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'config.editor'
require 'config.set'
require 'config.quickfix'
require 'config.window'
require 'config.autocmd'
require 'config.exec'

vim.filetype.add {
  pattern = {
    ['%.gitlab%-ci%.ya?ml'] = 'yaml.gitlab',
  },
}
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  { 'NMAC427/guess-indent.nvim', opts = {} },
  { 'pmizio/typescript-tools.nvim', dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' }, opts = {} },
  { 'ThePrimeagen/vim-be-good' },
  { import = 'kickstart.plugins' },
  -- NOTE: For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope! In normal mode type `<space>vh` then write `lazy.nvim-plugin`
  -- HACK: You can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
