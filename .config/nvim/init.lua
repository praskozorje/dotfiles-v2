require("settings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins with lazy.nvim
require("lazy").setup("plugins")

vim.lsp.enable('gopls')
vim.api.nvim_set_hl(0, "ColorColumn", {bg = '#FCF5E4' })

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.o.guifont = 'JetBrainsMonoNL Nerd Font:h12'
end

--vim.cmd.colorscheme("gruber-darker")
--vim.cmd([[colorscheme modus_operandi]]) -- modus_operandi, modus_vivendi
