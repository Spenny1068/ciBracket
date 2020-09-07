" Vim global plugin for adding support for ci<bracket type> that works in the same way ci" works.
" Author:   Spencer Lall
" Last Change:  2020 Sep 5
" License:      MIT

" avoid loading this script twice
if exists("g:loaded_ciBracket")
    finish
endif
let g:loaded_ciBracket = 1

let g:pairDictionary = { '(': ')',
                        \')': '(',
                        \'[': ']',
                        \']': '[',
                        \'{': '}',
                        \'}': '{',
                        \'<': '>',
                        \'>': '<', }

" onoremap mapping gets executed if its after an operator command
" <c-u> -> after : is entered, clear the command line by removing the inserted range.
onoremap i :<c-u>call <SID>NextString()<CR>

" execute operator on next string contained in target_char
function! s:NextString()
    let l:target_char = nr2char(getchar())
    "let l:paired_char = g:pairDictionary[l:target_char]

    if search(l:target_char, '', line('.')) || search(l:target_char, 'b', line('.'))
        execute "normal! vi". l:target_char
    else
        echo "character not found"
    endif
endfunction
