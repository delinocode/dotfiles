return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {
      http = {
        taichi = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "taichi",
            env = {
              url = "http://127.0.0.1:11434",
            },
            schema = {
              model = {
                default = "qwen3.8:27b-q8_0",
              },
            },
          })
        end,

        macpro_ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "macpro-ollama",
            env = {
              url = "http://macpro:11434",
            },
            schema = {
              model = {
                default = "qwen3.8-flash-next:125b-mlx",
              },
            },
          })
        end,

        macpro_serve = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "macpro-serve",
            env = {
              url = "http://macpro:11234/v1",
              api_key = "OPENAI_API_KEY",
            },
            schema = {
              model = {
                default = "labhraighlep/Qwen3.8-Flash-Next-MLX-Serve-4bit",
              },
            },
          })
        end,
      },
    },

    strategies = {
      chat = {
        adapter = "taichi",
      },
      inline = {
        adapter = "taichi",
      },
    },

    display = {
      chat = {
        window = {
          position = "right",
          width = 60,
        },
      },
    },
  },
}
