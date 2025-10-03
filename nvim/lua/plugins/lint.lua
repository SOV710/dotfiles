return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters.vale = {
        name = 'vale',
        cmd = 'vale',
        stdin = false,
        append_fname = false,
        args = { '--output=JSON', '$FILENAME' },
        stream = 'stdout',
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local ok, decoded = pcall(vim.fn.json_decode, output)
          if not ok or not decoded then
            return {}
          end
          local diags = {}
          for _, file in pairs(decoded) do
            for _, issue in ipairs(file) do
              table.insert(diags, {
                bufnr = bufnr,
                lnum = issue.Line - 1,
                col = issue.Span.start_char,
                end_col = issue.Span.end_char,
                severity = issue.Severity == 'error' and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                message = issue.Message,
                source = 'vale',
              })
            end
          end
          return diags
        end,
      }

      lint.linters_by_ft = {
        html = { 'vale' },
        markdown = { 'vale' },
        rst = { 'vale' },
        text = { 'vale' },
      }

      -- Note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }

      lint.linters_by_ft['clojure'] = nil
      lint.linters_by_ft['dockerfile'] = nil
      lint.linters_by_ft['inko'] = nil
      lint.linters_by_ft['janet'] = nil
      lint.linters_by_ft['json'] = nil
      lint.linters_by_ft['ruby'] = nil
      lint.linters_by_ft['terraform'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
