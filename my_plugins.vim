call plug#begin('~/.config/nvim/plugged')

	Plug 'tpope/vim-fugitive'
	Plug 'easymotion/vim-easymotion'
	Plug 'kien/ctrlp.vim'
	Plug 'bling/vim-airline'
	Plug 'majutsushi/tagbar'
	Plug 'scrooloose/nerdtree'
	Plug 'christoomey/vim-tmux-navigator'
	Plug 'epeli/slimux'
	Plug 'tpope/vim-unimpaired'
	Plug 'frankier/neovim-colors-solarized-truecolor-only'
	Plug 'airblade/vim-gitgutter'
	Plug 'jeetsukumaran/vim-buffergator'
	Plug 'simnalamburt/vim-mundo' " unlimited undo tree, like Gundo but with live depelopment community
	Plug 'benekastah/neomake' " pylint and make in backgroup
	Plug 'milkypostman/vim-togglelist' " toggle quickfix/location list with simple mapping
	Plug 'wellle/tmux-complete.vim' " complete from words in other buffers

call plug#end()

