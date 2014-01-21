" File: tabrename.vim
" Description: Set names for tab pages ( "Call stack", "Help tab", "Broswser" for example ). Useful for console tab mode
" Author: Reese Wilson
" Email: reese@shinymayhem.com
" Usage:
"   :TabRename tabname - set name for current tab page
"   :TabUnname - remove name 

if exists('tab_rename_plugin')
    finish
endif

let tab_rename_plugin = 1 "only load once

"globals that start with a capital are saved with the session
let g:Tab_list = get(g:, "Tab_list", "")

function! s:RenameTab(name)
    let t:tab_name = a:name
    call s:RefreshTab()
endfunction

function! s:UnnameTab()
    unlet t:tab_name
    call s:RefreshTab()
endfunction

function! s:RefreshTab()
    if exists("g:SessionLoad")
        " Do nothing if a session is loading. This ensure that custom tab names
        " are correctly restored with s:TabRestore(), which is triggered by
        " the SessionLoadPost event.
        return
    endif
    set tabline=%!TabCaptionLine()
    if has('gui_running')
        set guitablabel=%{TabGuiCaptionLabel()}
    endif
endfunction

function! TabCaptionLabel(number)
    let caption = ""
    let tab_name = gettabvar(a:number, 'tab_name') 

    let buflist = tabpagebuflist(a:number)
    let winnr = tabpagewinnr(a:number)
    let buf_name = bufname(buflist[winnr - 1])

    if tab_name == ''
        let bufname = pathshorten(buf_name)
        if bufname == ""
            let caption .= "no name"
        else
            "let caption .= "b:".bufname
            let caption .= "no name"
        endif
    else
        let caption .= tab_name
    endif
    return caption
endfunction

function! TabGuiCaptionLabel()
    let caption = '['
    let tab_number = v:lnum
    let bufnrlist = tabpagebuflist(tab_number)
    let tab_name = gettabvar(tab_number, 'tab_name')

    let caption .= tab_number

    for bufnr in bufnrlist
        if getbufvar(bufnr, "&modified")
            let caption .= '+'
            break
        endif
    endfor

    let caption .= ']'

    let winnr = tabpagewinnr(tab_number)
    let buf_name = bufname(bufnrlist[winnr - 1])
    if tab_name == ''
        let bufname = pathshorten(buf_name)
        if bufname == ""
            let caption .= "no name"
        else
            "let caption .= "b:".bufname
            let caption .= "no name"
        endif
    else
        let caption .= tab_name
    endif

    return caption
endfunction

function! TabCaptionLine()
    let line = ''
    let g:Tab_list = ""
    for i in range(tabpagenr('$'))

        let modified_part = ''
        let bufnrlist = tabpagebuflist(i+1)
        for bufnr in bufnrlist
            if getbufvar(bufnr, "&modified")
                let modified_part = '+'
                break
            endif
        endfor

        let caption = '['.(i+1).modified_part.']'
        let line .= '%#String#'.caption
        " select the highlighting
        if i + 1 == tabpagenr()
            let line .= '%#TabLineSel#'
        else
            if i % 2 == 0
                let line .= '%#TabLine#'
            else
                let line .= '%#TabLine#'
            endif
        endif

        let line .= '%' . (i + 1) . 'T'
        let label = TabCaptionLabel(i + 1)
        let line .= " ".label." "
        let g:Tab_list .= (i+1)."\t".label."\n"
    endfor

    let line .= '%#TabLineFill#%T'

    if tabpagenr('$') > 1
        let line .= '%=%#TabLine#%999Xclose'
    endif

    return line
endfunction

function! s:TabRestore()
    if !empty(g:Tab_list)
        for rawtab in split(get(g:, 'Tab_list', ""), "\n")
            let tabnr = split(rawtab, "\t")[0]
            let label = split(rawtab, "\t")[1]
            call settabvar(tabnr, "tab_name", label)
        endfor
    endif
endfunction
    
augroup TabLabelNameAU
    au!
    au SessionLoadPost * call s:TabRestore()
augroup END

call s:RefreshTab()

command! -nargs=1 TabRename call s:RenameTab(<q-args>)
command! TabUnname call s:UnnameTab()


