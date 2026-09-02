return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim", -- Optional: for better input prompts
  },
  config = function()
    require("codecompanion").setup({
      display = {
        chat = {
          window = {
            position = "right", -- Agent panel on right like VSCode/Cursor
            width = 60,
          },
        },
      },
      adapters = {
        -- Local Ollama on Taichi
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "ollama",
            url = "http://127.0.0.1:11434",
            model = {
              default = "qwen3.8:27b-q8_0",
            },
          })
        end,
        -- Remote Ollama on MacPro
        macpro_ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "macpro-ollama",
            url = "http://macpro:11434",
            model = {
              default = "qwen3.8-flash-next:125b-mlx",
            },
          })
        end,
        -- MLX on MacPro
        macpro_mlx = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "macpro-mlx",
            url = "http://macpro:11234",
            model = {
              default = "Qwen3.8-Flash-Next-oQ4e-MTP-128k",
            },
          })
        end,
        -- Anthropic Claude (requires ANTHROPIC_API_KEY env var)
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            name = "anthropic",
            env = {
              api_key = "ANTHROPIC_API_KEY",
            },
            model = {
              default = "claude-sonnet-4-20250514",
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "ollama", -- Default adapter for chat
        },
        inline = {
          adapter = "ollama", -- Default adapter for inline completions
        },
      },
    })
  end,
}
