return {
  'chomosuke/typst-preview.nvim',
  lazy = false,
  version = '1.*',
  opts = {
    debug = false,
    port = 8000,
    invert_colors = 'always',
    follow_cursor = 'true',
    dependencies_bin = {
      ['tinymist'] = 'tinymist',
      ['websocat'] = nil,
    },
    extra_args = nil,

    get_root = function(path_of_main_file)
      local root = os.getenv 'TYPST_ROOT'
      if root then
        return root
      end
      return vim.fn.fnamemodify(path_of_main_file, ':p:h')
    end,

    get_main_file = function(path_of_buffer)
      return path_of_buffer
    end,
  },
}
