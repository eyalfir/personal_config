source ~/.config/nvim/my_plugins.vim

syntax enable
set background=dark
"colorscheme solarized

" a single back directory for all files
set backupdir=~/.vimbackup

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

" send execfile(filename) when pressing <Leader>ir
nmap <Leader>ir :call SlimuxSendCode(join(['execfile("',expand("%"),'")'], ''))<CR>
let g:slimux_select_from_current_window = 1
let g:slimux_exclude_vim_pane = 1
let g:slimux_filter_out_panes = 'SYNCING'

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
highlight CursorColumn ctermbg=234 cterm=None term=None
au BufEnter * set cursorline
au BufEnter *.js,*.vue set cursorcolumn
au BufLeave * set nocursorline
au BufLeave * set nocursorcolumn
set nocursorline

" ctrlP customization
let g:ctrlp_show_hidden = 1
let g:ctrlp_extensions = ["tag"]
"let g:ctrlp_custom_ignore = '\v\.(git|pyc|pcap|expected|ps1|no_file)$'
"let g:ctrlp_custom_ignore = 'node_modules\|\.git'
let g:ctrlp_custom_ignore = 'node_modules/\|\.git/'

silent! unmap <C-P>
nmap <C-P><C-P> :<C-U>CtrlP<CR>
nmap <C-P><C-T> :<C-U>CtrlPTag<CR>
nmap <C-P><C-O> :<C-U>CtrlPBuffer<CR>

" fugitive shortcuts
command! GCommitLog Glog -- %
" \\v to Ggrep
nmap <Leader><Leader>v :Ggrep <C-r><C-w><CR><CR>:cope<CR>
nmap <silent> <leader>gb :Gblame<CR>
nmap <silent> <leader>gs :Gstatus<CR>
nmap <silent> <leader>gd :Gdiff<CR>
nmap <silent> <leader>gl :Glog<CR>
nmap <silent> <leader>gco :Gcommit<CR>
nmap <silent> <leader>gcw :Gcommit -m 'wip'<CR>
nmap <silent> <leader>gcb :Unite giti/branch_recent<CR>

autocmd! BufEnter *fugitiveblame nmap K 0yaw:!git log -n1 <C-R>"<CR>
autocmd! BufLeave *fugitiveblame nunmap K

function! UpdateTags()
  call system('ctags -R')
endfunction
" au BufWritePost *.py call UpdateTags()
nmap <silent> <Leader>ct :call UpdateTags()<CR>:echo "Tags Updated!"<CR>


" \ib to add pdb breakpoint
function! InsertSettrace()
  let br = expand("import pdb; pdb.set_trace()")
  execute "normal o".br
endfunction
autocmd FileType python noremap <Leader>ib :call InsertSettrace()<CR>
autocmd FileType yaml noremap <Leader>ib ^lli-<Esc>
autocmd FileType dot nnoremap M :GraphvizCompile<CR>:GraphvizShow<CR>

" workaround for the terrible neovim issue #2048 https://github.com/neovim/neovim/issues/2048
nnoremap <C-Q> :TmuxNavigateLeft<CR>

" configure airline
let g:airline#extensions#tagbar#flags = 'f'
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline_section_y = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1

" configure unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <silent> <C-p><C-s> :Unite -start-insert tmuxcomplete<CR>
nnoremap <silent> <C-p><C-l> :Unite -start-insert tmuxcomplete/lines<CR>

" paste toggle sane
set pastetoggle=
noremap <silent> cop :set paste!<CR>

" no mouse
set mouse=

" bind NERDTree
nmap <silent> <leader>n :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$']
nnoremap <silent> <leader>d :NERDTreeFind<CR>

nmap <silent> <leader>rt :TagbarOpen<CR>

" git gutter plugin toggle, and clear SignColumn background not aligned with
" solarized colorscheme
let g:gitgutter_notify_toggle = 1
nmap <silent> cog :GitGutterToggle<CR>
highlight clear SignColumn

autocmd! BufWritePost * Neomake
highlight NeomakeErrorSign ctermfg=red |
highlight NeomakeWarningSign ctermfg=yellow
highlight NeomakeWarning ctermfg=yellow

nnoremap <silent> <leader>m :MundoToggle<CR>

let g:neomake_python_enabled_makers = ['python', 'pylint']

nnoremap <leader><leader>r :source ~/.config/nvim/init.vim<CR>
nnoremap <leader><leader>e :e ~/.config/nvim/init.vim<CR>
nnoremap <leader><leader><leader>e :e ~/.config/nvim/my_plugins.vim<CR>

nnoremap <leader>j :w! /tmp/.vim_to_jira<CR>:!jiracli -m "$(cat /tmp/.vim_to_jira)" --issue-comment-add 
vnoremap <leader>j :w! /tmp/.vim_to_jira<CR>:!jiracli -m "$(cat /tmp/.vim_to_jira)" --issue-comment-add 

" I usually name my mako template files with .template extension
au BufRead,BufNewFile *.template set filetype=mako

" UltiSnips configuration
nnoremap <silent> cs :UltiSnipsEdit<CR>
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<a-n>"
let g:UltiSnipsJumpBackwardTrigger="<a-p>"

" slack visual selection with \ts
vnoremap <leader>ts :w! /tmp/send_to_slack<CR>:terminal python /Users/eyal/bin/interactive_slack.py /tmp/send_to_slack<CR>
nnoremap <leader>ts :w! /tmp/send_to_slack<CR>:terminal python /Users/eyal/bin/interactive_slack.py /tmp/send_to_slack<CR>
nnoremap <C-T> "zyy:!set -o errexit; echo <C-r>z \| egrep 'MAGNA-[0-9]*' \| sed 's/.*\(MAGNA-[0-9]*\).*/\1/' \| xargs -n1 -I@@ open https://lightcyber.atlassian.net/browse/@@<CR>


" SudoWrite
function! SudoWrite()
	let undofile = fnameescape(substitute(expand("%:p"), "/", "%", "g"))
	exec "wundo" . &undodir . "/" . undofile
	execute ":write !sudo dd of=" . shellescape(@%, 1)
endfunction

function! CdToCurrent()
	let current_directory=system('dirname ' . expand('%:p'))
	call SlimuxSendCode("cd " . current_directory)
endfunction

nnoremap <leader>cd :call CdToCurrent()<CR>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <M-l> <S-Right>
cnoremap <M-h> <S-Left>
cnoremap <M-k> <Right>
cnoremap <M-j> <Left>

autocmd! BufWritePost *personal.yml :echo system("cp ~/work/personal.yml /tmp/personal.yml.$(date +%Y%m%dT%H%M%S).backup && trello_sync update 2>&1 | tee -a /tmp/sync.log && trello_sync fetch > ~/work/personal.yml")
autocmd! FileReadPre *personal.yml !trello_sync fetch > ~/work/personal.yml
autocmd! FileType vue setlocal expandtab tabstop=2 shiftwidth=2
autocmd! FileType javascript setlocal expandtab tabstop=2 shiftwidth=2
nmap <C-f> :Ggrep '
set updatetime=100
command Lightcyber e ~/work/lightcyber/Jenkinsfile
