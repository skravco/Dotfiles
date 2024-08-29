set number             " Enable line numbers
set cursorline         " Highlight the current line
set wrap               " Enable line wrapping
set showmatch          " Show matching brackets/parentheses
set encoding=utf-8     " Set file encoding to UTF-8


" Syntax and file type settings
syntax on
filetype plugin indent on

" Indentation settings
set tabstop=4 shiftwidth=4 expandtab  " Set tab width and use spaces instead of tabs
set autoindent smartindent            " Auto-indent based on previous line

" Enhanced search behavior
set hlsearch incsearch ignorecase smartcase  " Search settings

" Disable backup and swap files
set nobackup nowritebackup noswapfile

" Status line and command height
set laststatus=2 showcmd cmdheight=2 ruler

" Faster response and more context lines when scrolling
set updatetime=500 scrolloff=5

" Set the leader key
let mapleader = ' '

" Keybindings for splits and closing splits with file path completion
nnoremap <leader>v :call SplitOrClose('v')<CR>
nnoremap <leader>h :call SplitOrClose('h')<CR>
nnoremap <leader>q :call SplitOrClose('q')<CR>

function! SplitOrClose(action)
    if a:action == 'v'
        let filepath = input('Vertical Split File Path: ', '', 'file')
        if filepath != ''
            exec 'vsplit ' . filepath
        endif
    elseif a:action == 'h'
        let filepath = input('Horizontal Split File Path: ', '', 'file')
        if filepath != ''
            exec 'split ' . filepath
        endif
    elseif a:action == 'q'
        close
    endif
endfunction


" Colors and themes
if !has('gui_running')
    set t_Co=256
endif
set termguicolors

colorscheme koehler

highlight StatusLine ctermfg=black ctermbg=yellow guifg=black guibg=yellow



