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

augroup aencrypted
	au!
	" First make sure nothing is written to ~/.viminfo while editing
	" an encrypted file.
	autocmd BufReadPre,FileReadPre          *.asc set viminfo=
	" We don't want a swap file, as it writes unencrypted data to disk
	autocmd BufReadPre,FileReadPre          *.asc set noswapfile
	" Switch to binary mode to read the encrypted file
	autocmd BufReadPre,FileReadPre          *.asc set bin
	autocmd BufReadPre,FileReadPre          *.asc let ch_save = &ch|set ch=2
	autocmd BufReadPost,FileReadPost        *.asc '[,']!sh -c "gpg --decrypt 2> /dev/null"
	" Switch to normal mode for editing
	autocmd BufReadPost,FileReadPost        *.asc set nobin
	autocmd BufReadPost,FileReadPost        *.asc let &ch = ch_save|unlet ch_save
	autocmd BufReadPost,FileReadPost        *.asc execute ":doautocmd BufReadPost " . expand("%:r")
	" Convert all text to encrypted text before writing
	autocmd BufWritePre,FileWritePre        *.asc   '[,']!sh -c "gpg --default-recipient-self -ae 2>/dev/null"
	" Undo the encryption so we are back in the normal text, directly
	" after the file has been written.
	autocmd BufWritePost,FileWritePost        *.asc   u
augroup END

augroup bencrypted
	au!
	" First make sure nothing is written to ~/.viminfo while editing
	" an encrypted file.
	autocmd BufReadPre,FileReadPre          *.gpg set viminfo=
	" We don't want a swap file, as it writes unencrypted data to disk
	autocmd BufReadPre,FileReadPre          *.gpg set noswapfile
	" Switch to binary mode to read the encrypted file
	autocmd BufReadPre,FileReadPre          *.gpg set bin
	autocmd BufReadPre,FileReadPre          *.gpg let ch_save = &ch|set ch=2
	autocmd BufReadPost,FileReadPost        *.gpg '[,']!sh -c "gpg --decrypt 2> /dev/null"
	" Switch to normal mode for editing
	autocmd BufReadPost,FileReadPost        *.gpg set nobin
	autocmd BufReadPost,FileReadPost        *.gpg let &ch = ch_save|unlet ch_save
	autocmd BufReadPost,FileReadPost        *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
	" Convert all text to encrypted text before writing
	autocmd BufWritePre,FileWritePre        *.gpg   '[,']!sh -c "gpg --default-recipient-self --armor -ev 2>/dev/null"
	" Undo the encryption so we are back in the normal text, directly
	" after the file has been written.
	autocmd BufWritePost,FileWritePost        *.gpg   u
augroup END
