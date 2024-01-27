# Hacking file with some tips

## Errors found in Apple M1

If you are using iTerm2 as the terminal emulator and you find an error with `nvim-treesitter` regarding the architecture (some `.so` file compiled for x86_64) then you probably should erase these files and launch nvim with the native terminal of the machine. If you do that, probably LazyVim will install the files again but for the correct architecture.
