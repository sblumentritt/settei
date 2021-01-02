-- --------------------------------------
-- entry point for neovim
-- --------------------------------------

-- define value for <leader> as early as possible
-- --------------------------------------
vim.g.mapleader = ","

-- disable some standard plugins
-- --------------------------------------
vim.g.loaded_gzip = 1

vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- load other lua modules
-- --------------------------------------
require("core.options").setup()
require("core.plugins").setup()
require("core.mappings").setup()
