return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    vim.cmd 'syntax enable'
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.maplocalleader = ','
  end,
}
