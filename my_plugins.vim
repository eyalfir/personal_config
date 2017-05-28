call plug#begin('~/.config/nvim/plugged')

	Plug 'tpope/vim-fugitive', { 'branch': 'blame_message' }
	Plug 'easymotion/vim-easymotion'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'bling/vim-airline'
	Plug 'majutsushi/tagbar'
	Plug 'scrooloose/nerdtree'
	Plug 'christoomey/vim-tmux-navigator'
	Plug 'tmux-plugins/vim-tmux'
	Plug 'epeli/slimux'
	Plug 'tpope/vim-unimpaired'
	Plug 'altercation/vim-colors-solarized'
	Plug 'sophacles/vim-bundle-mako'
	Plug 'SirVer/ultisnips'
	Plug 'airblade/vim-gitgutter'
	Plug 'jeetsukumaran/vim-buffergator'
	Plug 'simnalamburt/vim-mundo' " unlimited undo tree, like Gundo but with live depelopment community
	Plug 'benekastah/neomake' " pylint and make in backgroup
	Plug 'milkypostman/vim-togglelist' " toggle quickfix/location list with simple mapping
	Plug 'wellle/tmux-complete.vim' " complete from words in other buffers
        Plug 'Shougo/unite.vim' " unite interface for general lists
	Plug 'tmux-plugins/vim-tmux-focus-events'
	Plug 'kmnk/vim-unite-giti' " unite interface for git stuff

call plug#end()

