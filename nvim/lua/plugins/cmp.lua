return {
  'saghen/blink.cmp',
  build = 'cargo build --release',

  dependencies = {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    config = function()
      require('luasnip.loaders.from_lua').lazy_load {
        paths = { vim.fn.stdpath 'config' .. '/lua/plugins/snippets' },
      }
    end,
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'super-tab',

      -- ctrl+space for accept completion
      ['<C-space>'] = {
        function(cmp)
          cmp.accept { index = 1 }
        end,
      },

      ['<C-k>'] = {
        function(cmp)
          cmp.select_prev { auto_insert = false }
        end,
      },
      ['<C-j>'] = {
        function(cmp)
          cmp.select_next { auto_insert = false }
        end,
      },

      ['<C-Up>'] = {
        function(cmp)
          cmp.scroll_documentation_up(4)
        end,
      },
      ['<C-Down>'] = {
        function(cmp)
          cmp.scroll_documentation_down(4)
        end,
      },
    },

    cmdline = {
      keymap = { preset = 'inherit' },
      completion = { menu = { auto_show = true } },
    },

    snippets = { preset = 'luasnip' },

    appearance = { nerd_font_variant = 'mono' },

    menu = {
      draw = {
        components = {
          kind_icon = {
            Method = 'm',
          },
        },
      },
    },

    completion = {
      keyword = { range = 'full' },
      documentation = { auto_show = true },
      ghost_text = {
        enabled = true,
        show_with_menu = true,
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
