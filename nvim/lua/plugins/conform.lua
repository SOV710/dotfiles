return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = 'n',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = false, cpp = false }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },

      python = { 'ruff' },

      lua = { 'stylua' },

      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier' },

      go = { 'gofumpt' },

      sh = { 'shfmt' },
      bash = { 'shfmt' },
      ksh = { 'shfmt' },
      zsh = { 'shfmt' },
    },
  },
  formatters = {
    clangformat = {
      command = 'clang-format',
      args = '-style=file:/home/chris/.config/clang-format/.clang-format',
    },
  },
}
