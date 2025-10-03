return {
  -- LSP Plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { 'nvim-dap-ui' },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {},
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'clangd',
          'pyright',
          'ts_ls',
          'html',
          'cssls',
          'gopls',
          'rust_analyzer',
          'lua_ls',
          'bashls',
          'vue_ls',
          'sqls',
          'vimls',
          'neocmake',
          'dockerls',
          'docker_compose_language_service',
          'just',
          'jsonls',
          'yamlls',
          'tombi',
        },
      }

      local lsp_keymaps = {
        -- Jump to the definition of the word under your cursor.
        { 'ld', vim.lsp.buf.definition, 'definition' },
        -- Jump to the declaration of the word under your cursor.
        --  For example, in C this would take you to the header.
        { 'lD', vim.lsp.buf.declaration, 'declaration' },
        -- Jump to the type of the word under your cursor.
        { 'lt', vim.lsp.buf.type_definition, 'typeDefinition' },
        -- Find references for the word under your cursor.
        { 'lr', vim.lsp.buf.references, 'references' },
        -- Jump to the implementation of the word under your cursor.
        { 'li', vim.lsp.buf.implementation, 'implementation' },
        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        { 'ls', require('telescope.builtin').lsp_document_symbols, nil },
        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        { 'lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, nil },
        -- Rename the variable under your cursor
        { 'ln', vim.lsp.buf.rename, 'rename' },
        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        { 'lc', vim.lsp.buf.code_action, 'codeAction' },
      }

      local function has(bufnr, method)
        method = method:find '/' and method or 'textDocument/' .. method
        for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
          if client.supports_method(method, bufnr) then
            return true
          end
        end
        return false
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach-event', { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          for _, map in ipairs(lsp_keymaps) do
            local lhs, fn, method = map[1], map[2], map[3]
            if not method or has(bufnr, method) then
              vim.keymap.set('n', '<leader>' .. lhs, fn, {
                buffer = bufnr,
              })
            end
          end
        end,
      })
    end,
  },
}
