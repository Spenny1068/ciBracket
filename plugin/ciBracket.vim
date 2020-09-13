" Author:       Spencer Lall
" Last Change:  2020 Sep 7
" License:      MIT

" avoid loading this script twice
if exists("g:loaded_ciBracket")
    finish
endif

" ============================= GLOBAL VARIABLES ==============================
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

let g:override = 0

" ============================= FUNCTIONS ==============================

function! s:SetOverride()
    let g:override = 1
    call <SID>Main()
endfunction

" execute operator on string contained inside matching target_char
function! s:Main()
    let l:target_char = nr2char(getchar())

    if g:override
        call <SID>Run(l:target_char)

    else
        " need to skip comments here
        if s:IsBetween(l:target_char)
            call <SID>Default(l:target_char)
            return
        else
            call <SID>Run(l:target_char)
        endif
    endif

    let g:override = 0
endfunction

function! s:IsBetween(c)
    let l:paired_char = g:pairDictionary[a:c]
    return has_key(g:getOpeningPair, a:c) ? searchpair(l:paired_char, '', a:c, 'cnzW') :
                                          \ searchpair(a:c, '', l:paired_char, 'cnzW')
endfunction

function! s:Run(c)
    if search(a:c, '', line('.')) || search(a:c, 'b', line('.'))
        execute "normal! vi". a:c
    endif
endfunction

function! s:Default(c)
    if search(a:c, '', line('.'))
        execute "normal! vi". a:c
    endif
endfunction

" ============================= KEY MAPPINGS ==============================
if !hasmapto('<Plug>ciBracketMain', 'o')
    omap i <Plug>ciBracketMain
endif

" force ciBracket behaviour
if !hasmapto('<Plug>ciBracketYeet', 'o')
    omap I <Plug>ciBracketForceRun
endif

noremap <silent> <Plug>ciBracketMain :<c-u>call <SID>Main()<CR>
noremap <silent> <Plug>ciBracketForceRun :<c-u>call <SID>SetOverride()<CR>

