return {
  'esmuellert/nvim-eslint',

  require('nvim-eslint').setup {
    debug = true,

    settings = {
      format = true,
      quiet = false,
    },
    on_attach = function(client, bufnr)
      -- Enable completion capabilities
      if client.server_capabilities.document_formatting then
        vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
      end

      -- Attach nvim-cmp for completion
      local cmp = require 'cmp'
      cmp.setup.buffer {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }

      -- You can add more LSP capabilities if necessary, like auto-completion
    end,
  },
}
