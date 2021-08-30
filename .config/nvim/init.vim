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

if empty(glob(stdpath('data') . '/site/autoload/plug.vim'))
    echoerr 'vim-plug is not installed, plugins are not available.'
else
    call plug#begin(stdpath('data') . '/plugged')
    Plug 'itchyny/lightline.vim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'romgrk/barbar.nvim'
    Plug 'tpope/vim-commentary'
    call plug#end()

    " Status line (-- INSERT --) is unnecessary lightline is enabled.
    " https://github.com/itchyny/lightline.vim#introduction
    set noshowmode

    " nerd-tree
    nnoremap <C-n> :NvimTreeToggle<CR>

    " barbar
    nnoremap <silent>    <A-,> :BufferPrevious<CR>
    nnoremap <silent>    <A-.> :BufferNext<CR>
    nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
    nnoremap <silent>    <A->> :BufferMoveNext<CR>
    nnoremap <silent>    <A-1> :BufferGoto 1<CR>
    nnoremap <silent>    <A-2> :BufferGoto 2<CR>
    nnoremap <silent>    <A-3> :BufferGoto 3<CR>
    nnoremap <silent>    <A-4> :BufferGoto 4<CR>
    nnoremap <silent>    <A-5> :BufferGoto 5<CR>
    nnoremap <silent>    <A-6> :BufferGoto 6<CR>
    nnoremap <silent>    <A-7> :BufferGoto 7<CR>
    nnoremap <silent>    <A-8> :BufferGoto 8<CR>
    nnoremap <silent>    <A-9> :BufferLast<CR>
    nnoremap <silent>    <A-c> :BufferClose<CR>
endif

" Workaround for vim/neovim resize bug
" https://github.com/neovim/neovim/issues/11330#issuecomment-723667383
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"

" :help last-position-jump
autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

