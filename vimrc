" Load plugins
"
" nerdcommenter		syntastic		vim-airline-themes	vim-gitgutter
" nerdtree		vim-airline		vim-fugitive
"
execute pathogen#infect()

" Basic stuff
set tabstop=2
set shiftwidth=2
syntax enable
set number
set ruler
set cursorline
hi CursorLine term=bold cterm=bold
set cursorcolumn
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright
set ignorecase
set smartcase
set showtabline=2
set hlsearch
set showmode showcmd cmdheight=1
set laststatus=2
set wildmenu
nnoremap <leader>t :tabnew<cr>
map <C-\> :NERDTreeToggle<CR>
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
filetype plugin on
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:airline_theme='molokai'
