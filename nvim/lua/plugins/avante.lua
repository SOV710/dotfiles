return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  build = 'make',
  version = false, -- WARNING: Never set this to '*'!!!

  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = 'claude',
    providers = {
      claude = {
        endpoint = 'https://openrouter.ai/api/v1/chat/completions',
        model = 'claude-sonnet-4',
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
      moonshot = {
        endpoint = 'https://api.moonshot.cn/v1',
        model = 'moonshot-v1-128k',
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 32768,
        },
      },
    },
    mappings = {
      --- @class AvanteConflictMappings
      suggestion = {
        accept = '<C-y>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-n>',
      },
    },

    selector = {
      provider = 'telescope',
    },
    compat = {
      'avante_commands',
      'avante_mentions',
      'avante_files',
    },
    windows = {
      position = 'right',
      wrap = true,
      input = {
        height = 12,
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
