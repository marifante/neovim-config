local lspconfig = require("lspconfig")

lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    if client.name == "pyright" then
      print("pyright is enabled!")
    end
  end,
})
