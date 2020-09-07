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

let g:getOpeningPair = { ')': '(',
                        \']': '[',
                        \'}': '{',
                        \'>': '<', }

" <operator>i<target_char> is default. Change this mapping in .vimrc with ...
if !hasmapto('<Plug>ciBracketMain', 'o')
    omap i <Plug>ciBracketMain
endif

" Force yeet function
if !hasmapto('<Plug>ciBracketYeet', 'o')
    omap I <Plug>ciBracketYeet
endif

noremap <Plug>ciBracketMain :<c-u>call <SID>Main(0)<CR>
noremap <Plug>ciBracketYeet :<c-u>call <SID>Main(1)<CR>

" execute operator on string contained inside matching target_char
function! s:Main(force)
    let l:target_char = nr2char(getchar())

    " just yeet it
    if a:force
        if search(l:target_char, '', line('.')) || search(l:target_char, 'b', line('.'))
            execute "normal! vi". l:target_char
        endif

    " do checks
    else
        " if we are already inside brackets, use default behaviour 
        " need to skip comments here
        if s:IsBetween(l:target_char)
            return
            "execute "normal! ".v:operator."i".l:target_char
        else
            if search(l:target_char, '', line('.')) || search(l:target_char, 'b', line('.'))
                execute "normal! vi". l:target_char
            endif
        endif
    endif
endfunction

function! s:IsBetween(bracket)
    let l:paired_char = g:pairDictionary[a:bracket]
    if has_key(g:getOpeningPair, a:bracket)
        return searchpair(l:paired_char, '', a:bracket, 'cnzW')
    else
        return searchpair(a:bracket, '', l:paired_char, 'cnzW')
    endif
endfunction

function! s:Yeet(bracket)
endfunction

