return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  },
  {
    "3rd/image.nvim",
    config = function()
      require("image").setup({
        require("config.image"),
      })
    end,
  },
  {
    "3rd/diagram.nvim",
    dependencies = {
      "3rd/image.nvim",
      "luarocks.nvim",
    },
    config = function()
      require("config.diagram")
    end,
  },
}
