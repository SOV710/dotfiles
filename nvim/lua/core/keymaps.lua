-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = { noremap = true, silent = true }

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- NOTE: Remap 'Ctrl + [' to 'esc'
vim.keymap.set({ 'n', 'v', 'i', 'c' }, '<C-[', '<Esc>', { silent = true })

-- NOTE: Remap 'Ctrl + A' to 'select all'
vim.keymap.set('n', '<C-a>', 'ggVG', { silent = true })

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)
vim.keymap.set('n', 'dl', '"_dl', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Buffers
vim.keymap.set('n', '<leader>q', ':Bdelete!<CR>', { desc = 'Close buffer', silent = true, noremap = true }) -- close buffer
vim.keymap.set('n', '<leader>n', '<cmd> enew <CR>', { desc = 'New buffer', silent = true }) -- new buffer
-- NOTE: Require bufferline.nvim
vim.keymap.set('n', "'", '<Cmd>BufferLineCycleNext<CR>', { desc = 'Go to next buffer' })
vim.keymap.set('n', ';', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Go to previous buffer' })

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>n', function()
  local float_buf, float_win = vim.diagnostic.open_float(nil, {
    scope = 'line',
    focus = false, -- 先别自动聚焦
    focusable = true, -- 允许聚焦
    close_events = {}, -- 清空默认事件，不要自动关
  })

  if float_win and vim.api.nvim_win_is_valid(float_win) then
    -- 切到浮窗窗口
    vim.cmd(('noautocmd call nvim_set_current_win(%d)'):format(float_win))

    -- 在浮窗 buffer 上绑 <Esc> 和 q 关闭浮窗
    vim.keymap.set({ 'n' }, '<Esc>', function()
      vim.api.nvim_win_close(float_win, true)
    end, { buffer = float_buf, nowait = true, silent = true })

    vim.keymap.set({ 'n' }, 'q', function()
      vim.api.nvim_win_close(float_win, true)
    end, { buffer = float_buf, nowait = true, silent = true })
  end
end, { desc = 'Open diagnostic float and focus', silent = true })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Remove comflicts with Kitty's keymap
vim.keymap.set('n', '<S-A-.>', '', opts)
