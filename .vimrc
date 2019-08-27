set nocompatible

set backspace=indent,eol,start

set history=100
set ruler

set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg

" General
set encoding=utf-8

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
" https://www.reddit.com/r/Fedora/comments/ax9p9t/vim_and_system_clipboard_under_wayland/
xnoremap <C-c> "+y y:call system("wl-copy", @")<CR>
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" Fix mouse selection
" https://stackoverflow.com/questions/5728259/how-to-clear-the-line-number-in-vim-when-copying
se mouse+=a

" https://vi.stackexchange.com/questions/14357/moving-viminfo-file-to-vim-dir
set viminfo='50,<1000,s100,:0,n~/vim/viminfo

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

