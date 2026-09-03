local o = vim.opt

-- ============================================================
-- GENERAL
-- ============================================================

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2

o.number = true
o.relativenumber = true
o.signcolumn = 'yes'

o.ignorecase = true
o.smartcase = true

o.clipboard = 'unnamedplus'

o.scrolloff = 8
o.sidescrolloff = 8

o.undofile = true

o.termguicolors = true
o.cursorline = true

o.splitright = true
o.splitbelow = true

o.wrap = false

o.updatetime = 250
o.timeoutlen = 400

o.completeopt = {
  'menu',
  'menuone',
  'noselect',
}

o.mouse = 'a'

-- Don't show mode twice because we use the statusline.
o.showmode = false

-- Better search UX
o.hlsearch = true
o.incsearch = true

-- Keep sign column stable
o.signcolumn = 'yes'

-- Better command-line completion
o.wildmenu = true

-- Ask before destroying unsaved work
o.confirm = true

-- ============================================================
-- DIAGNOSTICS
-- ============================================================

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
  },

  signs = true,
  underline = true,

  update_in_insert = false,

  severity_sort = true,

  float = {
    border = 'rounded',
    source = 'if_many',
  },
})