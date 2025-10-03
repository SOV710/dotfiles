return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {},
  config = function()
    local toggleterm = require 'toggleterm'

    toggleterm.setup {
      open_mapping = [[<c-\>]],
      direction = 'float',
      float_opts = {
        border = 'double',
        width = 100,
        height = 30,
        title_pos = 'center',
      },
    }
  end,
}
