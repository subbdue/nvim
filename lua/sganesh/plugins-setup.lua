-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
  return
end

-- add list of plugins to install
return packer.startup(function(use)
  -- packer can manage itself
  use("wbthomason/packer.nvim")

  use("nvim-lua/plenary.nvim") -- lua functions that many plugins use

  use("bluz71/vim-nightfly-guicolors") -- preferred colorscheme

  use("christoomey/vim-tmux-navigator") -- tmux & split window navigation

  use("szw/vim-maximizer") -- maximizes and restores current window

  -- use("vhda/verilog_systemverilog.vim")
  use({ -- vim syntax plugin for verilog and systemverilog
    'vhda/verilog_systemverilog.vim',
    -- setup = function() require('sganesh.config.verilog_systemverilog').setup() end,
    -- config = function() require('sganesh.config.verilog_systemverilog').config() end
    config = function() require('sganesh.config.verilog_systemverilog') end
  })
  -- { -- vim syntax plugin for verilog and systemverilog
  --   'vhda/verilog_systemverilog.vim',
  --   lazy = true,
  --   ft = 'verilog_systemverilog',
  --   init = require('sganesh.config.verilog_systemverilog').setup,
  --   config = require('sganesh.config.verilog_systemverilog').config
  -- },
  -- 'MTDL9/vim-log-highlighting', -- syntax for log files

  -- essential plugins
  use("tpope/vim-surround") -- add, delete, change surroundings (it's awesome)
  use("inkarkat/vim-ReplaceWithRegister") -- replace with register contents using motion (gr + motion)

  -- commenting with gc
  use("numToStr/Comment.nvim")

  
  -- file explorer
  use("nvim-tree/nvim-tree.lua")

  -- vs-code like icons
  use("nvim-tree/nvim-web-devicons")

  -- statusline
  use("nvim-lualine/lualine.nvim")

  -- fuzzy finding w/ telescope
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
  use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
  use({ "nvim-telescope/telescope-ui-select.nvim" }) -- for showing lsp code actions

  -- autocompletion
  use("hrsh7th/nvim-cmp") -- completion plugin
  use("hrsh7th/cmp-buffer") -- source for text in buffer
  use("hrsh7th/cmp-path") -- source for file system paths

  -- snippets
  -- use("L3MON4D3/LuaSnip") -- snippet engine
  -- use("saadparwaiz1/cmp_luasnip") -- for autocompletion
  -- use("rafamadriz/friendly-snippets") -- useful snippets

  -- treesitter configuration
  -- use({
  --   "nvim-treesitter/nvim-treesitter",
  --   run = function()
  --     local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
  --     ts_update()
  --   end,
  -- })

  -- auto closing
  -- use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
  -- use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

  -- git integration
  use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

  if packer_bootstrap then
    require("packer").sync()
  end
end)
