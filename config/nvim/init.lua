-- --------------------------------------
-- entry point for neovim
-- --------------------------------------

-- define value for <leader> as early as possible
-- --------------------------------------
vim.g.mapleader = ','

-- save paths as vimscript environment variables
-- --------------------------------------
vim.env.neovim_data_dir = vim.fn.stdpath('data')..'/site'
vim.env.neovim_plugin_dir = vim.env.neovim_data_dir..'/pack/packer/start'

-- disable some standard plugins
-- --------------------------------------
vim.g.loaded_gzip = 1

vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- load plugins configuration file
-- --------------------------------------
require('plugins')

-- NOTE: is this still needed?
vim.cmd('filetype plugin indent on')
