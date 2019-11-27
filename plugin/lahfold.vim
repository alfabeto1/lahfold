"               _          __         _                   _
"              | |   _   _/_/___     / \   _ __ ___   ___| |__   __ _
"              | |  | | | | / __|   / _ \ | '__/ _ \ / __| '_ \ / _` |
"              | |__| |_| | \__ \  / ___ \| | | (_) | (__| | | | (_| |
"              |_____\__,_|_|___/ /_/   \_\_|  \___/ \___|_| |_|\__,_|
"
"                      _____     _     _ _____         _
"                     |  ___|__ | | __| |_   _|____  _| |_
"                     | |_ / _ \| |/ _` | | |/ _ \ \/ / __|
"                     |  _| (_) | | (_| | | |  __/>  <| |_
"                     |_|  \___/|_|\__,_| |_|\___/_/\_\\__|
"
" My very own FoldText function, with three levels of indent depending on
" foldlevel. Every level has it's own bullet point.
set foldtext=FoldText()
set fillchars=
" {{{
function! FoldText()
    " {{{
    " Vars
    let l:line   = 'Unnamed fold'
    let l:level  = v:foldlevel
    if ( l:level > 5 )
         l:level = 5
    endif
    " Different fillchars and bullets for foldlevel
    let l:fillchar  = '―'
    let l:fillchar2 = '╌'
    let l:fillchar2 = '…'
    let l:fillchar3 = '.'
    " let l:bullet    = '● '
    " let l:bullet2   = '▬ '
    " let l:bullet3   = '▪ '
    let l:bullet = '■ '
    let l:bullet2= '▪ '
    let l:bullet3= '▫ '
    if (l:level == 2)
        let l:fillchar  = l:fillchar2
        let l:bullet    = l:bullet2
    else
        if (l:level > 2)
            let l:fillchar = l:fillchar3
            let l:bullet   = l:bullet3
        endif
    endif

    " }}}
    " {{{
    " Calculating line len
    let l:maxlen    = &textwidth   " Max line len for fold header
    let l:foldlinelen=winwidth(0) - &foldcolumn
    if (&number)
        let l:foldlinelen=l:foldlinelen - &numberwidth -1
    endif
    if ( l:foldlinelen > l:maxlen)
        let l:foldlinelen = l:maxlen
    endif

    " }}}
    " {{{
    " Get text and clean
    for i in range(v:foldstart, v:foldend)
        if getline(i) =~ '^=' || getline(i) =~ '^=encoding' ||
         \ getline(i) !~? '[a-z]' || getline(i) =~ '^NUL='
            continue
        endif
        let l:line = (getline(i))
        break
    endfor
    let l:line = substitute(l:line, '^ *\/\/ *','','g')
    let l:line = substitute(l:line, '<!--','','g')
    let l:line = substitute(l:line, '-->','','g')
    let l:line = substitute(l:line, '"* *{{'.'{{*\d*','','g')
    let l:line = substitute(l:line, '#* *{{'.'{{*\d*','','g')
    let l:line = substitute(l:line, '"* *}}'.'}}*\d*','','g')
    let l:line = substitute(l:line, '#* *}}'.'}}*\d*','','g')
    let l:line = substitute(l:line, '\t',       ' ', 'g')
    let l:line = substitute(l:line, '\s\s\+',   ' ','g')
    let l:line = substitute(l:line, '\/\*',     '', 'g')
    let l:line = substitute(l:line, '\*\/',     '', 'g')
    let l:line = substitute(l:line, '#$',       '', 'g')
    let l:line = substitute(l:line, '|$',       '', 'g')
    let l:line = substitute(l:line, '^ *"\+ *', '', 'g')
    let l:line = substitute(l:line, '^ *#\+ *', '', 'g')
    let l:line = substitute(l:line, '\s*$',     '', 'g')
    let l:line = substitute(l:line, '^\s\+',    '', 'g')
    let l:line = substitute(l:line, '^-\+',     '', 'g')
    let l:line = substitute(l:line, '^_\+',     '', 'g')
    let l:line = substitute(l:line, '^\s\+',    '', 'g')
    let l:line = substitute(l:line, '\s*{$',    '', 'g')
    let l:line = substitute(l:line, '-\+$',     '', 'g')
    let l:line = substitute(l:line, '_\+$',     '', 'g')
    let l:line = substitute(l:line, ' $',       '', 'g')
    let l:line = substitute(l:line, '^ ',       '', 'g')
    let l:line = substitute(l:line, 'function ','', 'g')

    " }}}
    " {{{
    " Adjusting text
    " Left Indent
    let l:left    = repeat ('    ',l:level-1)

    " Right Indent
    let l:right   = 4 * (l:level-1)

    " Substr of line if too long
    let l:line    = strpart(l:line ,0,(l:foldlinelen - 7 - strlen(l:left)-l:right))
    let l:line    = l:line . ' '

    " Secondly line count
    let l:n       = v:foldend - v:foldstart + 1
    let l:n       = ' '.string(l:n)
    let l:nlen    = strlen(l:n)

    " }}}
    " {{{
    " Join it all and return
    let l:linelen = strlen(substitute(l:line,'.','x','g')) " Avoid utf8 multibyte
    let l:filler  = repeat(l:fillchar,(l:foldlinelen- l:nlen - 2 - strlen(l:left) - l:right - l:linelen))
    let l:line    = l:left.l:bullet.l:line. l:filler . l:n
    return l:line

    " }}}
endfunction
" }}}
