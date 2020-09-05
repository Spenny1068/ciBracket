" Vim global plugin for adding support for ci<bracket type> that works in the same way ci" works.
" Author:   Spencer Lall
" Last Change:  2020 Sep 4
" License:      This file is placed in the public domaim

" avoid loading this script twice
if exists("g:loaded_Bubba")
    finish
endif
let g:loaded_bubba = 1

map <unique> <Leader>t <Plug>BubbaEcho
noremap <unique> <script> <Plug>BubbaEcho <SID>Echo
noremap <SID>Echo : call <SID>Echo()<CR>

function! s:Echo()
    echo "hello world!"
endfunction
