syntax clear markdownCodeBlock

" define keywords/regions/matches
" --------------------------------------
syn region markdownCodeBlock
            \ start="\n\(    \|\t\)" end="\v^((\t|\s{4})@!|$)"
            \ contained
