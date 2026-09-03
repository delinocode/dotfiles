return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',

    event = {
      'BufReadPost',
      'BufNewFile',
    },

    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'css',
        'go',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'rust',
        'tsx',
        'typescript',
        'toml',
        'yaml',
      },

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },
    },
  },
}