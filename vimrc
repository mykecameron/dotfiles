set nocompatible               " be iMproved
filetype off                   " required!

" set leader to space
let mapleader = " "

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'VundleVim/Vundle.vim'

" vundles:
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'flazz/vim-colorschemes.git'
Bundle 'jwhitley/vim-matchit'
Bundle 'tComment'
Bundle 'ervandew/supertab'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-rails'
Bundle 'tsaleh/vim-shoulda'
Bundle 'vim-ruby/vim-ruby'
Bundle 'godlygeek/tabular'
Bundle 'Lokaltog/vim-powerline'
Bundle 'tpope/vim-endwise'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'embear/vim-localvimrc'
Bundle 'vim-syntastic/syntastic'

call vundle#end()
filetype plugin indent on     " required!

" powerline fancy symbols
let g:Powerline_symbols = 'fancy'

" syntax highlighting
syntax on

" colors
set t_Co=256
set background=dark
colorscheme jellybeans

" sane tab behavior
set tabstop=2     " size of a hard tabstop
set shiftwidth=2  " size of an "indent"
set softtabstop=2 " a combination of spaces and tabs are used to simulate tab stops at a width other than the (hard)tabstop
set expandtab     " always uses spaces instead of tab characters

set smarttab       " insert tabs on the start of a line according to shiftwidth, not tabstop
set nofoldenable
set number         " non-relative line numbers
set numberwidth=5  " minimum
set ruler          " show cursor position all the time
set nowrap         " don't wrap lines
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent
set copyindent     " copy previous indentation on autoindenting
set showmatch      " show matching parenthesis
set ignorecase     " ignore case when searching
set smartcase      " ignore case if search pattern is all lowercase, case-sensitive otherwise
set incsearch      " show search matches as you type
set hlsearch       " highlight matches
:nnoremap <CR> :nohlsearch<cr> " clear the search buffer when hitting return
set showcmd        " display incomplete commands
set modelines=2    " inspect top/bottom 2 lines for modeline
set scrolloff=3    " When scrolling, show 3 lines of context
set nojoinspaces   " Don't insert a space when joining lines, e.g. with J
set cursorline     " highlight cursor line
set mat=5          " Bracket blinking
set winwidth=85    " extend width on buffer change. 80 + 5 for numbers

" Open below and to the right, the same way you read a page
set splitbelow
set splitright

set encoding=utf-8
set fileencodings=utf-8,iso-8859-1
set fileformats=unix,mac,dos
set textwidth=0    " No width
set showbreak="@"  " This is prepended to wrapped lines

set list listchars=tab:»·,trail:· " Display extra whitespace
set laststatus=2                  " Always show status line (not only for multiple windows)

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

set undofile " Store undo history between buffer and file reloads and reopens

" For alignment (tabular plugin)
vmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a. :Tabularize /=><CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

" Align cucumber tables as you type
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

set undofile                " Save undo's after file closes
set undodir=$HOME/.vim_undo " where to save undo histories

set colorcolumn=81
let g:CommandTFileScanner = 'find'
set wildignore=node_modules/*,bower_components/*,dist/*,tmp/*

" Highlight EJS like HTML
au BufNewFile,BufRead *.ejs set filetype=html
