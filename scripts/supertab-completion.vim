function MyComplete()
    if &completefunc != ''
        return "\<c-x>\<c-u>"
    endif
endfunction

let g:SuperTabCompletionContexts=['MyComplete', 's:ContextText']
let g:SuperTabDefaultCompletionType="context"
