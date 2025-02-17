return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        disable_move = true,
        week_header = {
          enable = true,
        },
        shortcut = {
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            icon = ' ',
            desc = 'Manage Extensions',
            group = '@property',
            keymap = '',
            key = 'e',
            action = 'Mason',
          },
          {
            icon = ' ',
            desc = 'Config',
            group = 'Label',
            keymap = '',
            key = 'c',
            action = 'Telescope find_files cwd=~/.config/nvim',
          },
          {
            icon = ' ',
            desc = 'Exit',
            group = '@property',
            keymap = '',
            key = 'q',
            action = 'exit',
          },
        },
      },
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
