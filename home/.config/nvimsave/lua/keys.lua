local map = vim.keymap.set

-- ============================================================
-- BASIC
-- ============================================================

-- Escape = save
map('n', '<Esc>', '<cmd>update<cr>', {
  desc = 'Save',
})

-- Ctrl+S = save
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>update<cr>', {
  desc = 'Save',
})

-- Select all
map('n', '<C-a>', 'ggVG', {
  desc = 'Select All',
})

-- Don't lose clipboard when pasting over selection
vim.cmd([[xnoremap <expr> p 'pgv"'.v:register.'y']])

-- ============================================================
-- FILES / BUFFERS
-- ============================================================

map('n', '<leader>w', '<cmd>write<cr>', {
  desc = 'Save',
})

map('n', '<leader>q', '<cmd>quit<cr>', {
  desc = 'Quit',
})

map('n', '<leader>x', '<cmd>bdelete<cr>', {
  desc = 'Close Buffer',
})

map('n', '<leader>bn', '<cmd>bnext<cr>', {
  desc = 'Next Buffer',
})

map('n', '<leader>bp', '<cmd>bprevious<cr>', {
  desc = 'Previous Buffer',
})

-- ============================================================
-- WINDOWS
-- ============================================================

map('n', '<C-h>', '<C-w>h', {
  desc = 'Move Left',
})

map('n', '<C-l>', '<C-w>l', {
  desc = 'Move Right',
})

map('n', '<C-j>', '<C-w>j', {
  desc = 'Move Down',
})

map('n', '<C-k>', '<C-w>k', {
  desc = 'Move Up',
})

map('n', '<leader>sv', '<cmd>vsplit<cr>', {
  desc = 'Split Vertical',
})

map('n', '<leader>sh', '<cmd>split<cr>', {
  desc = 'Split Horizontal',
})

map('n', '<leader>sx', '<cmd>close<cr>', {
  desc = 'Close Split',
})

-- ============================================================
-- LSP
-- ============================================================

map('n', 'gd', vim.lsp.buf.definition, {
  desc = 'Go to Definition',
})

map('n', 'gD', vim.lsp.buf.declaration, {
  desc = 'Go to Declaration',
})

map('n', 'gr', vim.lsp.buf.references, {
  desc = 'References',
})

map('n', 'gi', vim.lsp.buf.implementation, {
  desc = 'Go to Implementation',
})

map('n', 'K', vim.lsp.buf.hover, {
  desc = 'Hover Documentation',
})

map('n', '<leader>rn', vim.lsp.buf.rename, {
  desc = 'Rename Symbol',
})

map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {
  desc = 'Code Action',
})

map('n', '<leader>ld', vim.diagnostic.open_float, {
  desc = 'Line Diagnostics',
})

map('n', '[d', vim.diagnostic.goto_prev, {
  desc = 'Previous Diagnostic',
})

map('n', ']d', vim.diagnostic.goto_next, {
  desc = 'Next Diagnostic',
})

-- ============================================================
-- TERMINAL
-- ============================================================

map('n', '<leader>t', '<cmd>terminal<cr>', {
  desc = 'Terminal',
})