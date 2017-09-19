" --------------- Plug ---------------
" https://github.com/junegunn/vim-plug
" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!mkdir -p ~/.vim/autoload'
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" CtrlP
Plug 'ctrlpvim/ctrlp.vim'

" Gundo
Plug 'sjl/gundo.vim'

" Initialize plugin system
call plug#end()

" formatting and lots of the settings taken from here:
" https://dougblack.io/words/a-good-vimrc.html

" --------------- Colors ---------------
colorscheme delek
syntax enable           " enable syntax processing

" --------------- Spaces & Tabs ---------------
set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set expandtab           " tabs are spaces


" --------------- UI Config ---------------
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set wildmode=list:longest
set scrolloff=10        " start scrolling when the cursor is within 10 lines of the edge
set showmatch           " highlight matching [{()}]

" --------------- Folding ---------------
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max

" space open/closes folds
nnoremap <space> za
set foldmethod=indent   " fold based on indent level

" move vertically by visual line TODO: do this with arrows?
nnoremap j gj
nnoremap k gk

" --------------- Leader shortcuts ---------------
" leader is a comma
let mapleader=","

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" save session
nnoremap <leader>s :mksession<CR>

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
"let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" --------------- Searching ---------------
set smartcase			      " only do a case sensitive search if the search term has an upper case
set pastetoggle=<F9>    " when you're pasting stuff this keeps it from getting
                        "  all whacked out with indentation
set incsearch           " incremental search
set hlsearch            " highlight matches

" turn off search highlight with ,<space>
nnoremap <leader><space> :nohlsearch<CR>

" --------------- Autogroups ---------------
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.py,*.js,*.txt,*.java,*.md,*.cc,*.cpp,*.h,*.hpp 
        \ :call <SID>StripTrailingWhitespaces()
    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END

"Automatically jump to the last line you were at (`" command does this)
autocmd BufReadPost *  exe "normal `\""

" --------------- Custom functions ---------------
" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc
nnoremap <leader>l :call ToggleNumber()<cr>

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s,\s\+$,,e
    let @/=_s
    call cursor(l, c)
endfunction

" recursively grep for word under cursor starting from current directory
nnoremap <silent> <C-F> :execute 'grep! -Irni ' . expand("<cword>") . ' *' <CR>:cw<CR>
