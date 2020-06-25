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
set tabstop=8
set softtabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" UI
set number
set showcmd
set cursorline
hi CursorLine   cterm=NONE ctermbg=234 ctermfg=NONE
filetype plugin indent on
set wildmenu
set lazyredraw
set showmatch

" Search
set incsearch
set hlsearch

" Copy & Paste
" https://vim.fandom.com/wiki/Accessing_the_system_clipboard
set clipboard=unnamedplus
" https://github.com/vim/vim/issues/5157
" vnoremap y y:call system("wl-copy", @")<cr>
" nnoremap p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p

" Fix mouse selection
" https://stackoverflow.com/questions/5728259/how-to-clear-the-line-number-in-vim-when-copying
set mouse+=a

" https://vi.stackexchange.com/questions/14357/moving-viminfo-file-to-vim-dir
set viminfo='50,<1000,s100,:0,n~/vim/viminfo

" https://vim.fandom.com/wiki/Highlight_unwanted_spaces#Highlighting_with_the_match_command
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
