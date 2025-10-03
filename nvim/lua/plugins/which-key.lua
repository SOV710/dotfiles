return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  dependencies = { 'echasnovski/mini.nvim' },
  opts = {
    delay = 0,
    icons = {
      keys = {
        Up = ' ',
        Down = ' ',
        Left = ' ',
        Right = ' ',
        C = '󰘴 ',
        M = '󰘵 ',
        D = '󰘳 ',
        S = '󰘶 ',
        CR = '󰌑 ',
        Esc = '󱊷 ',
        ScrollWheelDown = '󱕐 ',
        ScrollWheelUp = '󱕑 ',
        NL = '󰌑 ',
        BS = '󰁮',
        Space = '󱁐 ',
        Tab = '󰌒 ',
        F1 = '󱊫',
        F2 = '󱊬',
        F3 = '󱊭',
        F4 = '󱊮',
        F5 = '󱊯',
        F6 = '󱊰',
        F7 = '󱊱',
        F8 = '󱊲',
        F9 = '󱊳',
        F10 = '󱊴',
        F11 = '󱊵',
        F12 = '󱊶',
      },
    },
  },
  config = function()
    local wk = require 'which-key'

    local _debug = { icon = '󰃤', color = 'red' }
    local _telescope = { icon = '', color = 'blue' }
    local _lsp = { icon = '', color = 'cyan' }

    wk.add {
      -- NOTE: Debug
      { '<leader>d', group = '[D]ebug', icon = _debug },
      { '<leader>ds', desc = 'Debug: Start/Continue', icon = _debug },
      { '<leader>di', desc = 'Debug: Step Into', icon = _debug },
      { '<leader>dn', desc = 'Debug: Step Over', icon = _debug },
      { '<leader>do', desc = 'Debug: Step Out', icon = _debug },
      { '<leader>db', desc = 'Debug: Toggle Breakpoint', icon = _debug },
      { '<leader>dc', desc = 'Debug: Set Conditional Breakpoint', icon = _debug },
      { '<leader>de', desc = 'Debug: Terminate and Close', icon = _debug },
      { '<leader>du', desc = 'Debug: Toggle Debug UI', icon = _debug },

      -- NOTE: Telescope
      { '<leader>s', group = '[S]earch', icon = _telescope },
      { '<leader>sh', desc = '[S]earch [H]elp', icon = _telescope },
      { '<leader>sk', desc = '[S]earch [K]eymaps', icon = _telescope },
      { '<leader>sf', desc = '[S]earch [F]iles', icon = _telescope },
      { '<leader>ss', desc = '[S]earch [S]elect Telescope', icon = _telescope },
      { '<leader>sw', desc = '[S]earch current [W]ord', icon = _telescope },
      { '<leader>sg', desc = '[S]earch by [G]rep', icon = _telescope },
      { '<leader>sd', desc = '[S]earch [D]iagnostics', icon = _telescope },
      { '<leader>sr', desc = '[S]earch [R]esume', icon = _telescope },
      { '<leader>s.', desc = '[S]earch Recent Files ("." for repeat)', icon = _telescope },
      { '<leader><leader>', desc = '[ ] Find existing buffers', icon = _telescope },

      -- NOTE: LSP
      { '<leader>l', group = '[L]SP', icon = _lsp },
      { '<leader>ld', desc = 'Goto [D]efinition', icon = _lsp },
      { '<leader>lD', desc = 'Goto [D]eclaration', icon = _lsp },
      { '<leader>lt', desc = 'Goto [T]ype Definition', icon = _lsp },
      { '<leader>lr', desc = 'Find [R]eferences', icon = _lsp },
      { '<leader>li', desc = 'Goto [I]mplementation', icon = _lsp },
      { '<leader>ls', desc = 'Document [S]ymbols', icon = _lsp },
      { '<leader>lS', desc = 'Workspace [S]ymbols', icon = _lsp },
      { '<leader>ln', desc = 'Re[n]ame', icon = _lsp },
      { '<leader>lc', desc = '[C]ode Actions', icon = _lsp },

      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>r', group = '[R]ename' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    }
  end,
}
