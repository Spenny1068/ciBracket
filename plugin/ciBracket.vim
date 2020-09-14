" Author:       Spencer Lall
" Last Change:  2020 Sep 7
" License:      MIT

" avoid loading this script twice
if exists("g:loaded_ciBracket")
    finish
endif

" ============================= GLOBAL VARIABLES ==============================

let g:loaded_ciBracket = 1

let g:pairDict = { '(': ')',
                        \')': '(',
                        \'[': ']',
                        \']': '[',
                        \'{': '}',
                        \'}': '{',
                        \'<': '>',
                        \'>': '<', }

let g:openingPairDict = { ')': '(',
                        \']': '[',
                        \'}': '{',
                        \'>': '<', }

let g:override = 0

" =========================== HELPER FUNCTIONS ===============================

function! s:SetOverride()
    let g:override = 1
    call <SID>Main()
endfunction

function! s:IsBetween(c)
    let l:paired_char = g:pairDict[a:c]
    return has_key(g:openingPairDict, a:c) ? searchpair(l:paired_char, '', a:c, 'cnzW') :
                                          \ searchpair(a:c, '', l:paired_char, 'cnzW')
endfunction

function! s:Run(c)
    execute "normal! vi". a:c
endfunction

function! s:Default(c)
    execute "normal! vi". a:c
endfunction

" this function will return true if
" 1. forward: there is opening bracket on this line and it has a pair
" 2. backward: there is closing backet on this line and it has a pair
function! s:TargetOnLine(c)

    " get opening and closing bracket
    let l:opening_pair = has_key(g:openingPairDict, a:c) ? g:openingPairDict[a:c] : a:c
    let l:closing_pair = g:pairDict[l:opening_pair]
    let l:found_forward = 0
    let l:found_backward = 0

    " check if opening bracket exists forward in this line and it has a pair
    " while theres an opening bracket on this line
    while search(l:opening_pair, '', line('.'))
        if searchpair(l:opening_pair, '', l:closing_pair, 'nzW')
            let l:found_forward = 1
            break
        endif
    endwhile

    if l:found_forward
        while search(l:closing_pair, '', line('.'))
            if searchpair(l:closing_pair, '', l:opening_pair, 'nzW')
                let l:found_backward = 1
                break
            endif
        endwhile
    endif
    return l:found_forward || l:found_backward
endfunction

" ============================= MAIN FUNCTION ================================

function! s:Main()
    let l:target_char = nr2char(getchar())

    if s:IsBetween(l:target_char)
        if g:override
            if s:TargetOnLine(l:target_char)
                call <SID>Run(l:target_char)
            else
                call <SID>Default(l:target_char)
            endif
        else
            call <SID>Default(l:target_char)
        endif
    else
        if s:TargetOnLine(l:target_char)
            call <SID>Run(l:target_char)
        endif
    endif

    "if g:override
    "    call <SID>Run(l:target_char)
    "else
    "    " need to skip comments here
    "    if s:IsBetween(l:target_char)
    "        call <SID>Default(l:target_char)
    "        return
    "    else
    "        call <SID>Run(l:target_char)
    "    endif
    "endif

    let g:override = 0
endfunction

" ============================= KEY MAPPINGS ==============================
if !hasmapto('<Plug>ciBracketMain', 'o')
    omap i <Plug>ciBracketMain
endif

" force ciBracket behaviour
if !hasmapto('<Plug>ciBracketYeet', 'o')
    omap I <Plug>ciBracketForceRun
endif

noremap <Plug>ciBracketMain :<c-u>call <SID>Main()<CR>
"noremap <Plug>ciBracketMain :<c-u>call <SID>TargetOnLine()<CR>
noremap <Plug>ciBracketForceRun :<c-u>call <SID>SetOverride()<CR>

