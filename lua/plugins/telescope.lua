return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      -- fzf extension is being used by telescope-fzf-native
      {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "echasnovski/mini.icons" },
        opts = {},
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make", -- This ensures the fzf-native plugin is built properly
        config = function()
          require("telescope").load_extension("fzf") -- Load the fzf extension
        end,
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- Optionally set fzf defaults if desired
      --      telescope.load_extension("fzf")
    end,
  },
}
