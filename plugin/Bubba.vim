" Vim global plugin for adding support for ci<bracket type> that works in the same way ci" works.
" Author:   Spencer Lall
" Last Change:  2020 Sep 5
" License:      This file is placed in the public domaim

" avoid loading this script twice
if exists("g:loaded_ciBracket")
    finish
endif
let g:loaded_ciBracket = 1

" onoremap mapping gets executed if its after an operator command
" <c-u> -> after : is entered, clear the command line by removing the inserted range.
onoremap i :<c-u>call <SID>NextString()<CR>
onoremap I :<c-u>call <SID>PreviousString()<CR>
onoremap p :<c-u>call <SID>BiDirectionalString()<CR>

function! s:BiDirectionalString()
    let l:target_char = nr2char(getchar())
    echo "how do I do this :("
endfunction

" execute operator on next string contained in target_char
function! s:NextString()
    let l:target_char = nr2char(getchar())
    execute "normal! f". l:target_char. "vi". l:target_char
endfunction

" execute operator on previous string contained in target_char
function! s:PreviousString()
    let l:target_char = nr2char(getchar())
    execute "normal! F". l:target_char. "vi". l:target_char
endfunction
