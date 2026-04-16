-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.tabstop = 4 -- A TAB character looks like 4 spaces
opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
opt.shiftwidth = 4 -- Number of spaces inserted when indenting

-- Configure to show trailling whitespaces with a middle dot and
-- highlighter in red
opt.list = true
opt.listchars = { tab = "→ ", trail = "·" }

vim.cmd([[
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
]])

-- Command to remove trailling whitespaces from file
vim.cmd([[
  command! TrimWhitespace execute ':%s/\s\+$//e' | write
]])

-- Clipboard configuration with wayland support
if vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
  vim.g.clipboard = {
    name = "wl",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste",
    },
  }
  vim.opt.clipboard = "unnamedplus"
else
  vim.opt.clipboard = ""
end

-- Markdown list indentation (4 spaces for sub-items)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Markdown list formatting: insert newline between list items for mkdocs compatibility
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("i", "<CR>", function()
      local line = vim.fn.getline(".")
      local col = vim.fn.col(".")

      -- Check if current line is a list item (starts with -, *, +, or number.)
      if line:match("^%s*[-*+]%s") or line:match("^%s*%d+%.%s") then
        -- Insert newline
        vim.api.nvim_feedkeys(vim.keycode("<CR>"), "n", false)
        -- Add extra blank line if the next line is also a list item
        local next_line = vim.fn.getline(vim.fn.line(".") + 1)
        if next_line:match("^%s*[-*+]%s") or next_line:match("^%s*%d+%.%s") then
          vim.api.nvim_feedkeys(vim.keycode("<CR>"), "n", false)
        end
      else
        vim.api.nvim_feedkeys(vim.keycode("<CR>"), "n", false)
      end
    end, { noremap = true, buffer = true })
  end,
})
