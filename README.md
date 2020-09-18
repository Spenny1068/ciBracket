# ciBracket
Vim Plugin that extends ci" to ci(, ci{, ci[, ci<

By default, Vim allows you to edit/delete/yank/highlight/... text inside brackets or quotes by using the key strokes: ci), di), yi), vi), etc. As long as the cursor is inside the brackets or quotes to begin with.

It is seldom known that ci" and ci' (but not ci(, ci{, ci[ ...) will still work if the quotes are beyond your cursor, and on the same line.

ciBracket is a short script that extends this functionality to work on brackets as well as quotes while also providing
    - ability to change text beyond and before cursor on same line

# Use cases
Let x denote the particular bracket or quote you would like to edit between

If cursor is before or after pair of quotes/brackets, cix functions like ci"
if pairs of quotes/brackets exist on both sides of cursor, cix functions like ci" search with forwards priority
If cursor is between quotes/brackets, functionality will work as provided by Vim's default functionality
if cursor is between quotes/brackets with another pair of quotes/brackets, 
    - cix functions as provided by Vim's default functionality
    - cIx forces ci" like functionality on other set of quotes/brackets

## Installation

Install using your favorite package manager:

Plug:
    Plug 'Spenny1068/ciBracket'
Vundle:
    Plugin 'Spenny1068/ciBracket'

## Contributing

## License

Copyright (c) Spencer Lall.  Distributed under the same terms as Vim itself.
See `:help license`.
