" True color
set termguicolors

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
set cursorline

" Search
set incsearch
set hlsearch

" Copy & Paste
set clipboard+=unnamedplus

" Fix mouse selection
" https://stackoverflow.com/questions/5728259/how-to-clear-the-line-number-in-vim-when-copying
set mouse+=a

" https://vim.fandom.com/wiki/Highlight_unwanted_spaces#Highlighting_with_the_match_command
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/


call plug#begin(stdpath('data') . '/plugged')
Plug 'itchyny/lightline.vim'
call plug#end()

" By the way, -- INSERT -- is unnecessary anymore because the mode information is displayed in lightline statusline.
set noshowmode

