" ciBracket.vim - extends ci", ci' functionality to brackets 
" Author:       Spencer Lall
" License:      MIT

if exists("g:loaded_ciBracket") || v:version < 800
    finish
endif
let g:loaded_ciBracket = 1

" ============================= GLOBAL VARIABLES ==============================

let g:pairDict = { '(': ')', ')': '(',
                  \'[': ']', ']': '[',
                  \'{': '}', '}': '{',
                  \'<': '>', '>': '<', 
                  \"\"": "\"", "'": "'", }

let g:openingPairDict = { ')': '(',
                        \']': '[',
                        \'}': '{',
                        \'>': '<',
                        \"\"": "\"",
                        \"'": "'", }

let g:quoteList = ['"', '''', '`']

let g:override = 0
let g:isQuotes = 0

" =========================== HELPER FUNCTIONS ===============================

function! s:FindPair(c)
    if g:isQuotes
        call <SID>MatchQuote(a:c)
    else
        execute "normal! %"
    endif
endfunction

" move to matching quote and return true, if there is one. else don't move and
" return false
" credit: https://github.com/airblade/vim-matchquote
function! s:MatchQuote(c)

    let l:num = len(split(getline('.'), a:c, 1)) - 1
    if l:num % 2 == 1
        return 0
    endif

    let l:col = getpos('.')[2]
    let l:num = len(split(getline('.')[0:l:col-1], a:c, 1)) - 1
    execute (l:num % 2 == 0) ? "normal!F".a:c : "normal!f".a:c
    return 1

endfunction

function! s:SetOverride()
    let g:override = 1
    call <SID>Main()
endfunction

" check if cursor is between target_char. If it is return true. else return false
function! s:IsBetween(c)
    let l:opening_pair = has_key(g:openingPairDict, a:c) ? g:openingPairDict[a:c] : a:c
    let l:cursor_b = getcurpos()    " cursor before movement
    let l:cursor_a = 0              " cursor after movement
    let l:is_between = 0

    if search(l:opening_pair, 'Wb')
        call <SID>FindPair(a:c)
        let l:cursor_a = getcurpos()

        if (l:cursor_a[1] > l:cursor_b[1]) || ((l:cursor_a[1] == l:cursor_b[1]) && (cursor_a[2] > l:cursor_b[2]))
            let l:is_between = 1
        endif
    endif

    call setpos('.', l:cursor_b)
    return l:is_between
endfunction

function! s:Run(c)
    call <SID>FindTargetOnLine(a:c)
    execute "normal! vi". a:c
endfunction

function! s:Default(c)
    execute "normal! vi". a:c
endfunction

" find and move to target_char if it exists on current line and has a pair.
" else, do nothing
function! s:FindTargetOnLine(c)

    let l:opening_pair = has_key(g:openingPairDict, a:c) ? g:openingPairDict[a:c] : a:c
    let l:closing_pair = g:pairDict[l:opening_pair]
    let l:found_forward = 0
    let l:found_backward = 0

    if g:isQuotes
        if (search(a:c, '', line('.')) || search(a:c, 'b', line('.'))) && (s:MatchQuote(a:c))
            let l:found_forward = 1
        endif
    else
        while search(l:opening_pair, '', line('.'))
            if searchpair(l:opening_pair, '', l:closing_pair, 'nzW')
                let l:found_forward = 1
                break
            endif
        endwhile

        if !l:found_forward
            while search(l:closing_pair, 'b', line('.'))
                if searchpair(l:closing_pair, 'b', l:opening_pair, 'nzW')
                    let l:found_backward = 1
                    break
                endif
            endwhile
        endif
    endif
    return l:found_forward || l:found_backward
endfunction

" ============================= MAIN FUNCTION ================================

function! s:Main()
    let l:target_char = nr2char(getchar())

    " target_char is invalid
    if !has_key(g:pairDict, l:target_char)
        call <SID>Default(l:target_char)
        return
    endif

    " target_char is a quote
    if index(g:quoteList, l:target_char) >= 0
        let g:isQuotes = 1
    endif

    if s:IsBetween(l:target_char)
        if g:override
            call <SID>Run(l:target_char)
        else
            call <SID>Default(l:target_char)
        endif
    else
        call <SID>Run(l:target_char)
    endif

    let g:override = 0
    let g:isQuotes = 0
endfunction

" ============================= KEY MAPPINGS ==============================

if !hasmapto('<Plug>ciBracketMain', 'o')
    omap i <Plug>ciBracketMain
endif

" force ciBracket behaviour
if !hasmapto('<Plug>ciBracketForceRun', 'o')
    omap I <Plug>ciBracketForceRun
endif

noremap <silent> <Plug>ciBracketMain :<c-u>call <SID>Main()<CR>
noremap <silent> <Plug>ciBracketForceRun :<c-u>call <SID>SetOverride()<CR>
