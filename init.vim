source ~/.config/nvim/my_plugins.vim

syntax enable

set background=dark
source ~/Downloads/solarized-master/vim-colors-solarized/colors/solarized.vim
" a single back directory for all files
set backupdir=~/work

set history=100

" make Y act like D and C
map Y y$

let mapleader = "\\"

" ) and ( to switch between buffers
nmap <silent> ) :bnext<CR>
nmap <silent> ( :bprevious<CR>

" <Leader>r to search-replace
nmap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>

set nonumber

"set hidden allows switching freely between buffers
set hidden

function! SurroundWithCode() range
  let l1 = getpos("'<")[1]
  let l2 = getpos("'>")[1] + 1
  silent execute "normal! " . l2 . "G0i{code}"
  silent execute "normal! " . l1 . "G0i{code}"
endfunction

vmap <silent> <Leader>c :call SurroundWithCode()<CR>

" slimux bindings
nmap <Leader>s :SlimuxREPLSendLine<CR>
nmap <Leader>cs :SlimuxREPLConfigure<CR>

" send reload(module_name) when pressing <Leader>im (ipython-reload)
nmap <Leader>im :call SlimuxSendCode(join(['reload(',split(split(expand("%"),"/")[-1],".py")[0],')']))<CR>
" send execfile(filename) when pressing <Leader>ir
nmap <Leader>ir :call SlimuxSendCode(join(['execfile("',expand("%"),'")'], ''))<CR>
"let g:slimux_select_from_current_window = 1
"let g:slimux_exclude_vim_pane = 1
"let g:slimux_filter_out_panes = 'SYNCING'
  """ ********************
  """ enable sending %cpaste and then send code
function! GetVisualPlus() range
    let reg_save = getreg('"')
    let regtype_save = getregtype('"')
    let cb_save = &clipboard
    set clipboard&
    silent normal! ""gvy
    let selection = "%cpaste" . "\n" . getreg('"') . "--" . "\n"
    "let selection = "\n" . getreg('"') . "\n"
    call setreg('"', reg_save, regtype_save)
    let &clipboard = cb_save
    return selection
endfunction
command! -range=% -bar -nargs=* SlimuxPasteSelection call SlimuxSendCode(GetVisualPlus())
vmap <Leader>s :SlimuxPasteSelection<CR>
  """ **********************

"cursor line hightlight
highlight CursorLine ctermbg=234 cterm=None term=None
au BufEnter * set cursorline
au BufLeave * set nocursorline
set nocursorline

" ctrlP customization
let g:ctrlp_show_hidden = 1
let g:ctrlp_extensions = ["tag"]
silent! unmap <C-P>
nmap <C-P><C-P> :<C-U>CtrlP<CR>
nmap <C-P><C-T> :<C-U>CtrlPTag<CR>
nmap <C-P><C-O> :<C-U>CtrlPBuffer<CR>

" fugitive shortcuts
command! GCommitLog Glog -- %

function! UpdateTags()
  call system('ctags -R')
endfunction
" au BufWritePost *.py call UpdateTags()
nmap <silent> <Leader>ct :call UpdateTags()<CR>:echo "Tags Updated!"<CR>

" \\v to Ggrep
nmap <Leader><Leader>v :Ggrep <C-r><C-w><CR><CR>:cope<CR>

" \ib to add pdb breakpoint
function! InsertSettrace()
  let br = expand("import pdb; pdb.set_trace()")
  execute "normal o".br
endfunction
nmap <Leader>ib :call InsertSettrace()<CR>

" workaround for the terrible neovim issue #2048 https://github.com/neovim/neovim/issues/2048
nnoremap <C-Q> :TmuxNavigateLeft<CR>

" configure airline
let g:airline#extensions#tagbar#flags = 'f'
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline_section_y = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1

" paste toggle sane
set pastetoggle=
noremap <silent> cop :set paste!<CR>

" no mouse
set mouse=

" bind NERDTree
nmap <silent> <leader>n :NERDTreeToggle<CR>

nmap <silent> <leader>rt :TagbarOpen<CR>

" fugitive bindings
nmap <silent> <leader>gb :Gblame<CR>
nmap <silent> <leader>gs :Gstatus<CR>
nmap <silent> <leader>gd :Gdiff<CR>
nmap <silent> <leader>gl :Glog<CR>
nmap <silent> <leader>gc :Gcommit<CR>

" git gutter plugin toggle, and clear SignColumn background not aligned with
" solarized colorscheme
nmap <silent> cog :GitGutterToggle<CR>
highlight clear SignColumn

autocmd! BufWritePost * Neomake

nnoremap <leader>q :copen<CR>
nnoremap <leader>l :copen<CR>

nnoremap <silent> <leader>m :GundoToggle<CR>

let NERDTreeIgnore=['\.pyc$']
let g:ctrlp_custom_ignore = '\v\.(git|pyc|pcap|expected|ps1|no_file)$'

nnoremap <leader><leader>r :source ~/.config/nvim/init.vim<CR>
nnoremap <leader><leader>e :e ~/.config/nvim/init.vim<CR>
