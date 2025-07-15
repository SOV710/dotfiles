require 'core.options'
require 'core.keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
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
  require 'plugins.neo-tree',
  require 'plugins.telescope',
  require 'plugins.which_key',
  require 'plugins.bufferline',
  require 'plugins.todo_comments',
  require 'plugins.themes.tokyonight',
  -- NOTE: Editor
  require 'plugins.treesitter',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.tailwind',
  require 'plugins.trouble',
  -- require 'plugins.lint',
  require 'plugins.autoformat',
  require 'plugins.indent_line',
  require 'plugins.autopairs',
  -- NOTE: AI Tools
  require 'plugins.avante',
  -- NOTE: Version Control
  require 'plugins.gitsigns',
  -- NOTE: Debug
  require 'plugins.debug',
  require 'plugins.vimtex',
  require 'plugins.typst_preview',
  -- NOTE: Other
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
