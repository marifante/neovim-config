return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mrcjkb/rustaceanvim",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup mason-nvim-dap
    require("mason-nvim-dap").setup({
      automatic_setup = true,
      handlers = {},
      ensure_installed = { "codelldb" },
    })

    -- Setup nvim-dap-ui
    dapui.setup()

    -- Configure Rust/LLDB adapter
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.rust = {
      {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        showLog = false,
      },
    }

    -- Auto open/close dapui with debugger
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Keybindings
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Debug: Start/Continue"
    keymap.set("n", "<leader>dc", dap.continue, opts)

    opts.desc = "Debug: Step Over"
    keymap.set("n", "<leader>do", dap.step_over, opts)

    opts.desc = "Debug: Step Into"
    keymap.set("n", "<leader>di", dap.step_into, opts)

    opts.desc = "Debug: Step Out"
    keymap.set("n", "<leader>dO", dap.step_out, opts)

    opts.desc = "Debug: Toggle Breakpoint"
    keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)

    opts.desc = "Debug: Set Breakpoint with Condition"
    keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, opts)

    opts.desc = "Debug: Terminate"
    keymap.set("n", "<leader>dt", dap.terminate, opts)

    opts.desc = "Debug: Toggle DAP UI"
    keymap.set("n", "<leader>dU", dapui.toggle, opts)
  end,
}
