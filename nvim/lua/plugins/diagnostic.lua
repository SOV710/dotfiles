return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'LspAttach',
  lazy = false,
  priority = 1000,
  config = function()
    require('tiny-inline-diagnostic').setup {
      preset = 'modern',

      transparent_bg = false,
      transparent_cursorline = false,

      options = {
        show_source = {
          enabled = true,
        },

        multilines = {
          enabled = true,
          always_show = true,
        },

        show_all_diags_on_cursorline = true,
      },

      -- prevent to have all diagnostics in the buffer displayed.
      vim.diagnostic.config { virtual_text = false, virtual_lines = false },
    }
  end,
}
