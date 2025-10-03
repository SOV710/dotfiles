require 'core.autocmds'
require 'core.options'
require 'core.keymaps'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- NOTE: Appearance
  require 'plugins.dashboard',
  require 'plugins.lualine',
  require 'plugins.indent-line',
  require 'plugins.todo-comments',
  require 'plugins.themes.tokyonight',

  -- NOTE: Editing Flow
  require 'plugins.neo-tree',
  require 'plugins.telescope',
  require 'plugins.which-key',
  require 'plugins.bufferline',
  require 'plugins.toggleterm',

  -- NOTE: Development Tools
  require 'plugins.treesitter',
  require 'plugins.lint',
  require 'plugins.lsp',
  require 'plugins.cmp',
  require 'plugins.diagnostic',
  require 'plugins.dap',
  require 'plugins.conform',

  -- NOTE: AI Tools
  require 'plugins.avante',

  -- NOTE: Version Control
  require 'plugins.gitsigns',

  -- NOTE: Utils
  require 'plugins.mini',
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
