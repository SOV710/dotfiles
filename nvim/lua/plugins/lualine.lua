return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    local lualine = require 'lualine'

    lualine.setup {
      theme = 'material',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      sections = {
        lualine_a = {
          function()
            return ''
          end,
          'mode',
        },
      },
    }
  end,
}
