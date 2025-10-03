return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- There's a good go dap repo so I use it alone
    'leoluz/nvim-dap-go',
  },
  keys = {
    {
      '<leader>ds',
      function()
        require('dap').continue()
      end,
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<leader>dn',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<leader>do',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>dc',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Conditional Breakpoint',
    },
    {
      '<leader>de',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Terminate and Close',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle Debug UI',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      handlers = {},

      ensure_installed = {
        'codelldb',
        'debugpy',
        'js-debug-adapter',
        'delve',
      },
    }

    -- Dap UI setup
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        element = 'repl',
        enabled = true,
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      mappings = {},
      element_mappings = {},
      expand_lines = true,
      force_buffers = true,
      floating = {
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.35,
            },
            {
              id = 'breakpoints',
              size = 0.25,
            },
            {
              id = 'stacks',
              size = 0.25,
            },
            {
              id = 'watches',
              size = 0.15,
            },
          },
          position = 'left',
          size = 50,
        },
        {
          elements = { {
            id = 'repl',
            size = 0.5,
          }, {
            id = 'console',
            size = 0.5,
          } },
          position = 'bottom',
          size = 10,
        },
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        detached = vim.fn.has 'win32' == 0,
      },
    }

    dap.adapters.codelldb = {
      type = 'executable',
      command = 'codelldb',
    }

    local function find_root(buf)
      local path = vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
      return vim.fs.find({ 'CMakeLists.txt', '.git', 'compile_commands.json' }, { upward = true, path = path })[1] -- return full path or nil
    end

    local function make_c_or_cpp_config(lang)
      local buf = vim.api.nvim_get_current_buf()
      local rootf = find_root(buf)
      local proj = rootf and vim.fs.dirname(rootf) -- CMakeLists dir
        or vim.fn.expand '%:p:h' -- simgle file dir
      local build = proj .. '/build'
      local exe = build .. '/foo'
      local file = vim.api.nvim_buf_get_name(buf)

      local cmds
      if rootf then -- cmake project
        cmds = {
          ('platform shell mkdir -p %s'):format(build),
          ('platform shell cmake -S %s -B %s -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'):format(proj, build),
          ('platform shell cmake --build %s --config Debug -j32'):format(build),
        }
      else -- single file
        local std = (lang == 'cpp') and 'c++17' or 'c11'
        cmds = {
          ('platform shell mkdir -p %s'):format(build),
          ('platform shell clang -std=%s -g -O0 -Wall -Wextra -pedantic -o %s %s'):format(std, exe, file),
        }
      end

      return {
        name = 'Debug (' .. lang .. ')',
        type = 'codelldb',
        request = 'launch',
        cwd = proj,
        initCommands = cmds,
        targetCreateCommands = { 'target create ' .. exe },
        program = exe,
        exitCommands = { 'platform shell rm -rf ' .. build },
        stopOnEntry = false,
        terminal = 'integrated',
      }
    end

    dap.configurations.c = { make_c_or_cpp_config 'c' }
    dap.configurations.cpp = { make_c_or_cpp_config 'cpp' }

    -- dap.configurations.c = {
    --   {
    --     name = 'Launch files',
    --     type = 'codelldb',
    --     request = 'launch',
    --     cwd = '${workspaceFolder}',
    --     initCommands = {
    --       'platform shell mkdir -p ${workspaceFolder}/build',
    --       'platform shell clang -std=c11 -g -O0 -Wall -Wextra -pedantic -o ${workspaceFolder}/build/a.out ${file}',
    --     },
    --     targetCreateCommands = { 'target create ${workspaceFolder}/build/a.out' },
    --     program = '${workspaceFolder}/build/a.out',
    --     exitCommands = { 'platform shell rm -rf ${workspaceFolder}/build/' },
    --     stopOnEntry = false,
    --     terminal = 'integrated',
    --   },
    -- }

    -- dap.configurations.cpp = {
    --   {
    --     name = 'Launch files',
    --     type = 'codelldb',
    --     request = 'launch',
    --     cwd = '${workspaceFolder}',
    --     initCommands = {
    --       'platform shell mkdir -p ${workspaceFolder}/build',
    --       'platform shell clang -std=c++17 -g -O0 -Wall -Wextra -pedantic -o ${workspaceFolder}/build/a.out ${file}',
    --     },
    --     targetCreateCommands = { 'target create ${workspaceFolder}/build/a.out' },
    --     program = '${workspaceFolder}/build/a.out',
    --     exitCommands = { 'platform shell rm -rf ${workspaceFolder}/build/' },
    --     stopOnEntry = false,
    --     terminal = 'integrated',
    --   },
    -- }

    dap.configurations.rust = {
      {
        name = 'Debug (rust)',
        type = 'codelldb',
        request = 'launch',
        cwd = '${workspaceFolder}',
        cargo = {
          args = { 'build', '--bin=foo' },
          env = {
            RUST_BACKTRACE = '1',
            RUST_LOG = 'debug',
          },
          problemMatcher = '$rustc',
        },
        terminal = 'integrated',
        sourceLanguages = { 'rust' },
      },
    }
  end,
}
