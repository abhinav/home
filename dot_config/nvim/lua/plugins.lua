-- Regenerate packer_compiled.lua on edit.
vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	augroup end
]])

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	-- Completion and snippets {{{2
	use 'andersevenrud/cmp-tmux'
	use 'honza/vim-snippets'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-omni'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/nvim-cmp'
	use 'quangnguyen30192/cmp-nvim-ultisnips'
	use 'SirVer/ultisnips'

	-- Editing {{{2
	use 'andymass/vim-matchup'
	use 'junegunn/vim-easy-align'
	use 'justinmk/vim-sneak'
	use 'mg979/vim-visual-multi'
	use 'machakann/vim-highlightedyank'
	use 'ntpeters/vim-better-whitespace'
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use 'tpope/vim-abolish'
	use 'tpope/vim-commentary'
	use 'tpope/vim-repeat'
	use 'tpope/vim-sleuth'
	use 'tpope/vim-surround'
	use 'tversteeg/registers.nvim'
	use 'vim-scripts/visualrepeat'
	use 'wsdjeg/vim-fetch'

	-- Filetype-specific {{{2
	use 'alker0/chezmoi.vim'
	use 'cappyzawa/starlark.vim'
	use 'cespare/vim-toml'
	use 'chrisbra/csv.vim'
	use 'direnv/direnv.vim'
	use 'habamax/vim-asciidoctor'
	use 'hynek/vim-python-pep8-indent'
	use {
		'iamcco/markdown-preview.nvim',
		ft = 'markdown',
		run = function()
			vim.fn['mkdp#util#install']()
		end,
	}
	use 'lervag/wiki.vim'
	use 'NoahTheDuke/vim-just'
	use 'rust-lang/rust.vim'
	use {'stacked-git/stgit', rtp = 'contrib/vim'}
	use 'vim-pandoc/vim-pandoc-syntax'
	use 'ziglang/zig.vim'

	-- Git {{{2
	use 'iberianpig/tig-explorer.vim'
	use 'rhysd/git-messenger.vim'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-rhubarb'

	-- Look and feel {{{2
	use 'edkolev/tmuxline.vim'
	use 'justinmk/molokai'
	use 'vim-airline/vim-airline'
	use 'vim-airline/vim-airline-themes'

	-- LSP and language features {{{2
	use 'dense-analysis/ale'
	use 'folke/lsp-colors.nvim'
	use 'folke/trouble.nvim'
	use 'neovim/nvim-lspconfig'
	use 'vim-test/vim-test'

	-- Navigation and window management {{{2
	use 'camspiers/lens.vim'
	use 'chrisbra/NrrwRgn'
	use 'junegunn/fzf.vim'
	vim.opt.rtp:append { "~/.fzf" } -- managed by chezmoi
	use {'junegunn/goyo.vim', cmd = 'Goyo'}
	use 'justinmk/vim-dirvish'
	use 'mhinz/vim-grepper'
	use 'rbgrouleff/bclose.vim'

	-- Terminal integration {{{2
	use 'christoomey/vim-tmux-navigator'
	use 'ojroques/vim-oscyank'
	use 'vim-utils/vim-husk'
	use {'voldikss/vim-floaterm', run = 'pip install --upgrade neovim-remote'}
end)
