if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert

  " Command-T for CommandT
  macmenu &File.New\ Tab key=<D-T>
  map <D-t> :CommandT<CR>
  imap <D-t> <Esc>:CommandT<CR>
endif

" Don't beep
set visualbell

" Start without the toolbar
set guioptions-=T

" Default gui color scheme
color ir_black

" Font
set guifont=Monaco:h9.5

" Margin
set textwidth=100
set cc=+1 " Add margin after textwidth
