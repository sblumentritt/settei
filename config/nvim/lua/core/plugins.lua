-- @module core.plugins
local plugins = {}

function plugins.setup()
    -- check and ensure that packer.nvim is installed
    local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.cmd("silent !git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    end

    -- search in the optional plugin directory for the given plugin
    vim.cmd("packadd packer.nvim")

    require("packer").startup(function()
        -- let packer.nvim manage itself
        use {"https://github.com/wbthomason/packer.nvim", opt = true}

        -- completion related
        use {"https://github.com/nvim-lua/completion-nvim",
            requires = {
                {"https://github.com/steelsojka/completion-buffers"},
                {"https://gitlab.com/s.blumentritt/cmake.vim"},
                {"https://gitlab.com/s.blumentritt/bitbake.vim"},
            },
            config = require("settings.completion").setup()
        }

        -- lsp related
        use {"https://github.com/neovim/nvim-lspconfig",
            requires = {
                {"https://github.com/nvim-lua/lsp-status.nvim"},
                {"https://github.com/glepnir/lspsaga.nvim"},
            },
            config = require("settings.lsp").setup()
        }

        -- git related
        use {"https://github.com/itchyny/vim-gitbranch"}
        use {"https://github.com/airblade/vim-gitgutter"}
        use {"https://github.com/rhysd/git-messenger.vim"}

        -- other filetype specific plugins
        use {"https://github.com/cespare/vim-toml"}
        use {"https://github.com/tpope/vim-markdown"}
        use {"https://github.com/MTDL9/vim-log-highlighting"}
        use {"https://github.com/euclidianAce/BetterLua.vim"}

        -- utilities
        use {"https://github.com/moll/vim-bbye"}
        use {"https://github.com/junegunn/fzf.vim"}
        use {"https://github.com/norcalli/nvim-colorizer.lua",
            config = require("settings.colorizer").setup()
        }
        use {"https://github.com/mbbill/undotree"}
    end)

    require("settings.mixed").setup()
end

return plugins
