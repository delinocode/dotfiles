return {
  {
    'stevearc/conform.nvim',

    event = {
      'BufWritePre',
    },

    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },

        python = {
          'ruff_format',
          'ruff_organize_imports',
        },

        go = { 'gofmt' },

        rust = { 'rustfmt' },

        sh = { 'shfmt' },

        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },

        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },

        json = { 'prettier' },
        yaml = { 'prettier' },

        markdown = { 'prettier' },
      },

      format_on_save = {
        timeout_ms = 1000,
        lsp_format = 'fallback',
      },
    },
  },
}