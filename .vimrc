" --------------- Plugins ---------------
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'cdelledonne/vim-cmake'
Plug 'rhysd/vim-clang-format'
Plug 'vim-airline/vim-airline'
Plug 'farmergreg/vim-lastplace'
call plug#end()

let g:coc_global_extensions = [
    \'coc-clangd',
    \'coc-json',
    \'coc-python'
    \]

" formatting and lots of the settings taken from here:
" https://dougblack.io/words/a-good-vimrc.html

" --------------- Colors ---------------
syntax enable           " enable syntax processing
" Improve the colors used for some CoC windows
highlight Pmenu ctermbg=gray ctermfg=white
highlight CocErrorFloat ctermfg=130

" --------------- Spaces & Tabs ---------------
set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set expandtab           " tabs are spaces
set shiftwidth=4        " the number of space characters inserted for indentation
set bs=2                " Allow backspacing over everything in insert mode

" --------------- UI Config ---------------
set cursorline              " highlight current line
filetype plugin indent on   " load filetype-specific indent files
" TODO: Don't think these are needed anymore?
" set wildmenu                " visual autocomplete for command menu
" set wildmode=list:longest
set scrolloff=10            " start scrolling when the cursor is within 10 lines of the edge
set showmatch               " highlight matching [{()}]

" move vertically by visual line TODO: do this with arrows?
nnoremap j gj
nnoremap k gk

" --------------- Leader shortcuts ---------------
" leader is a comma
let mapleader=","

" save session
nnoremap <leader>s :mksession<CR>

" allows cursor change in tmux mode
" TODO: still needed?
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" --------------- Searching ---------------
set ignorecase
set smartcase			" only do a case sensitive search if the search term has an upper case
set pastetoggle=<F9>    " when you're pasting stuff this keeps it from getting
                        "  all whacked out with indentation
set incsearch           " incremental search
set hlsearch            " highlight matches

" turn off search highlight with ,<space>
nnoremap <leader><space> :nohlsearch<CR>

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" CtrlP options
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$|docker_build.*$|build.*$|INPUT.*$|OUTPUT.*$',
  \ 'file': '\v\.(exe|so|o|pyc|dll)$',
  \ }
let g:ctrlp_use_caching = 0

autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.vert,*.frag :ClangFormat

" Make the highlight on cursorhold faster
set updatetime=1000

" Map ctrl-shift-r to run the current test
nnoremap <C-R> :cexpr system('cd /home/lal/volume/_docker_build; ../.vscode/vsc_build_test.sh build_and_run ' . expand('%:p'))<cr>:copen<cr>

" Overwrite makeprg to our build command
set makeprg=ninja\ -C\ /home/lal/volume/_docker_build\ -j\ 10
" Map ctrl-shift-b to build all
" NOTE: this first one is what vscode runs, but it doesn't seem to support the
" -C 'working dir' arg like make & ninja do (see
"  https://vi.stackexchange.com/questions/2331/quickfix-with-makeprg-running-in-a-different-directory)
"  is there a way to make it work with cmake? (do we care?)
"nnoremap <C-B> :cexpr system('/usr/bin/cmake --build /home/lal/volume/_docker_build --config Debug --target all -j 10 --')<cr>:copen<cr>
"nnoremap <C-B> :cexpr system('ninja -C /home/lal/volume/_docker_build -j 10')<cr>:copen<cr>
nnoremap <C-B> :make<cr>:copen<cr>

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

" key-notation fields pulled from :h key-notation
" turned a line of 8 hex values into hex byte pairs, i.e.:
" DEADBEEF -> 0xDE, 0xAD, 0xBE, 0xEF, <CR>
let @b = "i0x\<Right>\<Right>, 0x\<Right>\<Right>, 0x\<Right>\<Right>, 0x\<Right>\<Right>,\<Del>\<CR>\<Esc>"
let @c = "4@b"

set noswapfile
