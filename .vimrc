set nocompatible

" vim-plug
"
" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'vim-airline/vim-airline'

" Initialize plugin system
call plug#end()

set viminfo='50,<1000,s100,:0,n~/vim/viminfo
set backspace=indent,eol,start

set history=100
set ruler

set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg

" General
set encoding=utf8

" Syntax & Scheme
syntax enable

" Spaces & Indent
set smarttab
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" UI
set number
set showcmd
set cursorline
hi CursorLine   cterm=NONE ctermbg=234 ctermfg=NONE
filetype indent on
set wildmenu
set lazyredraw
set showmatch

" Search
set incsearch
set hlsearch

" Copy & Paste
" https://superuser.com/questions/10588/how-to-make-cut-copy-paste-in-gvim-on-ubuntu-work-with-ctrlx-ctrlc-ctrlv/189198#189198
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" Fix mouse selection
" https://stackoverflow.com/questions/5728259/how-to-clear-the-line-number-in-vim-when-copying
se mouse+=a

