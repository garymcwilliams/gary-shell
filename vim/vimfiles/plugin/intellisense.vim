"---------------------> Intellisense Feature <----------------------
" Author       : Ravi Shankar & Madan Ganesh
" Dated        : September 01, 2003
" Last modified by : David Fishburn
" Last Modified: Tue Sep 21 2004 12:14:52 PM
" Version : $Name: RELEASE_1_4_1 $ , $Revision: 1.7 $
" Website: http://insenvim.sourceforge.net
" Date : $Date: 2005/07/28 11:53:08 $
" 
"Copyright (C) 2004  Ravi Shankar and Madan Ganesh
"
"This program is free software; you can redistribute it and/or
"modify it under the terms of the GNU General Public License
"as published by the Free Software Foundation; either version 2
"of the License, or (at your option) any later version.
"
"This program is distributed in the hope that it will be useful,
"but WITHOUT ANY WARRANTY; without even the implied warranty of
"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"GNU General Public License for more details.
"
"You should have received a copy of the GNU General Public License
"along with this program; if not, write to the Free Software
"Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.


if exists('g:loaded_intellisence')
    finish 
endif
let g:loaded_intellisence = 1

let g:intellisense_version = "1.4.1"
let g:intellisense_vimfiles = ""

" Variable initialization {{{
" Script variables for initialization
let s:intellisense_init_root   = 0
let s:intellisense_init_java   = 0
let s:intellisense_init_xml    = 0
let s:intellisense_init_html   = 0
let s:intellisense_init_baan   = 0
let s:intellisense_init_cs     = 0
let s:intellisense_init_sql    = 0

" Global defaults
let g:helpfg="default"
let g:helpbg="default"
let g:listfg="default"
let g:listbg="eclipseColor"

" Default settings, which can be overridden
" by each file / filetype
let s:dochelpdelay = "2000"
let s:ignorekeys = "_"
let s:delimiterkey = "("
let s:tooltipclosekey = ")"
let s:ignorecase = "0"
let s:helpwindowsize = "0x0" "Default size
let g:tmpdir = fnamemodify(tempname(), ":h").'/'
let s:vimroot = substitute(expand('$VIM'), "\\\w*$", "", "")

" $VIM is sometimes ends in Vim and sometimes to Vim\vim63 so we try both
" structures
if !isdirectory(s:vimroot . "Intellisense")
	if isdirectory(s:vimroot . "Vim\\Intellisense")
		let s:vimroot = s:vimroot . "vim\\"
	endif
endif

if !exists("g:intellisense_root_dir")
    if expand('$VIM_INTELLISENSE') != '$VIM_INTELLISENSE'
        let g:intellisense_root_dir = expand('$VIM_INTELLISENSE')
    elseif isdirectory(s:vimroot . "Intellisense")
        let g:intellisense_root_dir = s:vimroot . "Intellisense"
    else
        let g:intellisense_root_dir = ""
    endif
endif
let g:vissession = strftime("%Y-%b-%d-%H-%M-%S")
"You can give the colorname , which can be found at rgb.txt
" }}}

let s:PLUGIN_DIR = "/plugin/intellisense.vim"
let g:intellisense_vimfiles = expand('$HOME') . "/vimfiles"
let s:intellisense_plugin = g:intellisense_vimfiles . s:PLUGIN_DIR
if filereadable(s:intellisense_plugin) != 1

    let g:intellisense_vimfiles = s:vimroot . "vimfiles"
    let s:intellisense_plugin = g:intellisense_vimfiles . s:PLUGIN_DIR

    if filereadable(s:intellisense_plugin) != 1
        let s:intellisense_plugin = "   <UNKNOWN PATH>" . s:PLUGIN_DIR
    endif
endif

    
" Public functions {{{
function! IN_StartIntelliSense()
    " Initialize the environment to call the DLL.
    " This is done only once for the plugin
    "
    " It is done the first time an ftplugin trying to 
    " initialize Intellisense.  This is done so that the user
    " can check for messages when they think it should work.
    " Setting this up when the plugin loads, does not really
    " provide the user with a chance to look for errors, if
    " things are not working properly.
    if s:intellisense_init_root != 1
        let s:intellisense_init_root = s:IN_InitRoot()

        if s:intellisense_init_root != 1
            return s:intellisense_init_root
        endif
    endif

    let b:intellisense = s:IN_InitFileType()
    return b:intellisense

endfunction

function! IN_StopIntelliSense()
    let b:intellisense = 0
endfunction

function! IN_VisReload()
    let g:vissession = strftime("%Y-%b-%d-%H-%M-%S")
endfunction

function! IN_SetDlgColor(type,colorname)
    if(a:type == "helpfg")
        let g:helpfg= a:colorname
    elseif(a:type == "helpbg")
        let g:helpbg= a:colorname
    elseif(a:type == "listfg")
        let g:listfg= a:colorname
    elseif(a:type == "listbg")
        let g:listbg= a:colorname
    else
        call IN_WarningMsg( "Not a valid dialog" )
    endif

endfunction

function! IN_AddIgnoreKeys(keys)
    let b:ignorekeys = b:ignorekeys . a:keys
endfunction

function! IN_SetIgnoreKeys(keys)
    let b:ignorekeys = a:keys
endfunction

function! IN_SetDocDelayTime(delay)
    let b:dochelpdelay = a:delay
endfunction

function! IN_ShowVISDialog(vistype)
    " In general this function must return a blank line (or a value)
    " since the imaps use this form:
    "     imap . <C-R>=IN_ShowVISDialog(...)
    " If you simply use "return", then Vim actually does "return 0"
    " which inserts a 0 in the file being edited.

    if b:intellisense != 1 
        return ''
    endif

    " Do nothing if the current cursor position is part of a comment
    if s:IN_IsColComment(line('.'), (virtcol('.')-1)) == 1
        return ''
    endif

    if &filetype == 'sql'
        let objectName = s:IN_CreateVimHelper(a:vistype)
        " Do nothing
        if objectName == -1
            return ''
        endif
    else
        let objectName = s:IN_GetNearestWord()
    endif
    let l:tmpfile      = g:tmpdir . "viminsrc.tmp"
    let l:old_modified = &modified
    let l:cur_col      = col('.')
    let l:cur_line     = line('.')

    " Prevent the alternate buffer (<C-^>) from being set to this
    " temporary file
    let l:old_cpoptions   = &cpoptions
    " Many autocommands are geared on the BufWrite event.
    " Since we are not writing a file we are editing, disable
    " those autocommands, and re-enable when finished writing
    " the temporary file.
    let l:old_eventignore = &eventignore
    setlocal cpo-=A
    setlocal eventignore+=BufWrite,BufWritePre,BufWritePost,BufWriteCmd

    exe "silent write! " . l:tmpfile

    " Restore previous cpoptions
    let &cpoptions   = l:old_cpoptions
    let &eventignore = l:old_eventignore

    if(b:ignorekeys == "")
        let b:ignorekeys = "undefined"
    endif
    if(b:delimiterkey == "")
        let b:delimiterkey = "undefined"
    endif
    if(b:tooltipclosekey == "")
        let b:tooltipclosekey = "undefined"
    endif
    let l:cmd = l:tmpfile .
                \ "#visep#" . objectName .
                \ "#visep#" . cur_line . ":" . 
                \ cur_col . ":" . g:vissession .
                \ "#visep#" . expand("%:p") .
                \ "#visep#" .  v:servername .
                \ "#visep#" . &filetype .
                \ "#visep#" . a:vistype .
                \ "#visep#" . b:dochelpdelay .
                \ "!" . b:ignorekeys .
                \ "!" . b:delimiterkey .
                \ "!" . b:tooltipclosekey .
                \ "!" . b:ignorecase .
                \ "!" . b:helpwindowsize .
                \ "!" . g:listfg .
                \ "!" . g:listbg .
                \ "!" . g:helpfg .
                \ "!" . g:helpbg

    let l:dll = $VIM_INTELLISENSE . "/VimHelper"
    call libcall(l:dll,"StartVISDialog",l:cmd)
    let &modified = l:old_modified

    return ''
endfunction

function! IN_ExecCmd(name, ...)

    " Could not figure out how to do this with an unlimited #
    " of variables, so I limited this to 4.  Currently we only use
    " 1 parameter in the code (May 2004), so that should be fine.
    if a:0 == 0
        let result = s:IN_{toupper(&filetype)}_ExecCmd(a:name)
    elseif a:0 == 1
        let result = s:IN_{toupper(&filetype)}_ExecCmd(a:name, a:1)
    elseif a:0 == 2
        let result = s:IN_{toupper(&filetype)}_ExecCmd(a:name, a:1, a:2)
    elseif a:0 == 3
        let result = s:IN_{toupper(&filetype)}_ExecCmd(a:name, a:1, a:2, a:3)
    else
        let result = s:IN_{toupper(&filetype)}_ExecCmd(a:name, a:1, a:2, a:3, a:4)
    endif
    
    return result
endfunction
" }}}

" Script functions {{{
function! s:IN_GetNearestWord()
    let c = col ('.')-1
    let l = line('.')
    let ll = getline(l)
    if(strlen(ll) == 0) 
        return " "
    else
        return substitute(ll,"\\\\s*","","")
    endif
endfunction

function! IN_WarningMsg(msg)
    echohl WarningMsg
    echomsg a:msg 
    echohl None
endfunction
      
function! IN_ErrorMsg(msg)
    echohl ErrorMsg
    echomsg a:msg 
    echohl None
endfunction
      
function! s:IN_InitRoot()
    " Check if the intellisense files are available!
    if !isdirectory(expand(g:intellisense_root_dir))
        if g:intellisense_root_dir ==? '$VIM_INTELLISENSE'
            call IN_WarningMsg( "Cannot find Intellisense. " .
                    \ "Set the environment variable VIM_INTELLISENSE " .
                    \ "or in your .vimrc by let " .
                    \ " g:intellisense_root_dir=" .
                    \ "expand('$VIM/Intellisense')" 
                    \ )
        else
            call IN_WarningMsg( "Your g:intellisense_root_dir does not " .
                    \ "point to a valid directory"
                    \ )
        endif
        return -1
    else
        let $VIM_INTELLISENSE = g:intellisense_root_dir
    endif

    if(!has("libcall"))
        call IN_WarningMsg( "Vim must be compiled with libcall support" )
        return -1
    endif	

    if(!has("win32"))
        " Currently Intellisense is only available on win32 platforms
        return -1
    endif	

    return 1
endfunction

function! s:IN_InitFileType()

    " Default buffer specific settings
    let b:dochelpdelay    = s:dochelpdelay
    let b:ignorekeys      = s:ignorekeys
    let b:delimiterkey    = s:delimiterkey
    let b:tooltipclosekey = s:tooltipclosekey
    let b:ignorecase      = s:ignorecase
    let b:helpwindowsize  = s:helpwindowsize

    " First initialize filetypes, if any special processing is required
    " This is done before the root initialization for convience.
    if( &filetype == 'java' || &filetype == 'jsp' )
        " If java has been successfully initialized, there is no
        " need to redo this for each buffer
        if s:intellisense_init_java != 1
            let s:intellisense_init_java = s:IN_InitializeJava() 
        endif
        return s:intellisense_init_java
    endif

    if( &filetype == 'sql' )
        " SQL has buffer specific variables, so we must initialize
        " it each time
        " if !exists('b:intellisense_init_sql')
        "     let b:intellisense_init_sql = s:IN_InitializeSQL() 
        " endif
        " return b:intellisense_init_sql
        if s:intellisense_init_sql != 1
            let s:intellisense_init_sql = s:IN_InitializeSQL() 
        endif
        return s:intellisense_init_sql
    endif

    " Default, return success for those languages that do not 
    " require additional setup
    let s:intellisense_init_{&filetype} = 1

    return s:intellisense_init_{&filetype}
endfunction

function! s:IN_InitializeJava()
    " Check is jvm.dll is already in the PATH
    if strlen(globpath(substitute($PATH, ';', ',', 'g'), 'jvm.dll')) == 0

        if !exists('g:intellisense_jvm_dir')
            if isdirectory(expand($JAVA_HOME))
                let g:intellisense_jvm_dir  = expand('$JAVA_HOME\jre\bin\server')
            endif
        endif

        if !exists('g:intellisense_jvm_dir')
            call IN_WarningMsg( 
                        \ "Please specify the location of the jvm.dll in " .
                        \ "your .vimrc by: let " .
                        \ "g:intellisense_jvm_dir=expand('$JAVA_HOME\\jre\\bin\\server') ".
                        \ "or by creating a $JAVA_HOME environment variable."
                        \ )
            return -1
        endif

        if isdirectory(g:intellisense_jvm_dir)
            " If b:intellisense_jvm_dir is a valid directory
            " add it to the system PATH and check again
            let $PATH = $PATH . ';' . g:intellisense_jvm_dir
            if strlen(globpath(substitute($PATH, ';', ',', 'g'), 'jvm.dll')) == 0
                call IN_WarningMsg( "Cannot find jvm.dll in the location " .
                            \ "specified by your g:intellisense_jvm_dir"
                            \ )
                return -1
            endif
        else
            call IN_WarningMsg( 
                        \ "The g:intellisense_jvm_dir variable does not " .
                        \ "point to a valid directory"
                        \ )
            return -1
        endif
    endif

    if !exists('g:intellisense_javaapi_dir')
        if isdirectory(expand($JAVA_HOME))
            let g:intellisense_javaapi_dir  = expand('$JAVA_HOME\docs\api')
        endif
    endif

    if exists('g:intellisense_javaapi_dir')
        if isdirectory(g:intellisense_javaapi_dir)
            let $JAVA_DOCPATH = 
                        \ expand(g:intellisense_javaapi_dir)
        else
            call IN_WarningMsg( 
                        \ "The location specified by " .
                        \ "g:intellisense_javaapi_dir " .
                        \ "in your .vimrc does not exist."
                        \ )
        endif
    endif

    " Ensure javaft.jar is available in the classpath
    if $CLASSPATH != 'javaft\.jar'
        let $CLASSPATH = $CLASSPATH . ';' .
                    \ expand(g:intellisense_root_dir).'\javaft.jar'
    endif

    return 1
endfunction

function! s:IN_InitializeSQL()

    let sql_dir = g:intellisense_root_dir . '\sqlft'

    if !isdirectory(sql_dir)
        call system('mkdir ' . sql_dir)
        if !isdirectory(sql_dir)
            call IN_ErrorMsg('Failed to create directory: '.sql_dir)
            return -1
        endif
    endif
    
    " Generate (based on the syntax highlight rules) a list of
    " the Statements, functions, keywords and so on available
    " If this needs updating, the syntax\sql.vim file should be
    " updated
	if !filereadable(sql_dir . '/sqlstatements.txt')
        " Icon has an "S" on it
		let sqlStatements = s:IN_SyntaxList( 'sqlStatement', '11' )
		silent! echo "\n"
		exe "redir! > " . sql_dir . '/sqlstatements.txt'
		silent echo sqlStatements
		redir END
	endif
    
	if !filereadable(sql_dir . '/sqlfunctions.txt')
        " Icon has {}
		let sqlFunctions = s:IN_SyntaxList( 'sqlFunction', '60' )
		silent! echo "\n"
		exe "redir! > " . sql_dir . '/sqlfunctions.txt'
		silent echo sqlFunctions
		redir END
	endif
    
	if !filereadable(sql_dir . '/sqlkeywords.txt')
        " Icon has a key on it
		let sqlKeywords = s:IN_SyntaxList( 'sqlKeyword', '24' )
		silent! echo "\n"
		exe "redir! > " . sql_dir . '/sqlkeywords.txt'
		silent echo sqlKeywords
		redir END
	endif
    
	if !filereadable(sql_dir . '/sqloperators.txt')
        
		let sqlOperators = s:IN_SyntaxList( 'sqlOperator', '128' )
		silent! echo "\n"
		exe "redir! > " . sql_dir . '/sqloperators.txt'
		silent echo sqlOperators
		redir END
	endif
    
	if !filereadable(sql_dir . '/sqltypes.txt')
		let sqlTypes = s:IN_SyntaxList( 'sqlType', '32' )
		silent! echo "\n"
		exe "redir! > " . sql_dir . '/sqltypes.txt'
		silent echo sqlTypes
		redir END
	endif
    
	if !filereadable(sql_dir . '/sqloptions.txt')
		let sqlOptions = s:IN_SyntaxList( 'sqlOption', '64' )
		silent! echo "\n"
		exe "redir! > " . sql_dir . '/sqloptions.txt'
		silent echo sqlOptions
		redir END
	endif
    
	if !filereadable(sql_dir . '/sqlall.txt')
		silent! echo "\n"
		exe "redir! > " . sql_dir . '/sqlall.txt'
		silent echo sqlStatements
		silent echo sqlFunctions
		silent echo sqlKeywords
		silent echo sqlOperators
		silent echo sqlTypes
		silent echo sqlOptions
		redir END
	endif
    
    " Number of files to cache with temporary column lists
    if !exists('g:IN_sql_mru_max')
        let g:IN_sql_mru_max = 10
    endif

    " Define the temporary file all column lists will use
    let s:IN_sql_cols_file = g:tmpdir. 'IN_SQL_cols.txt'

    " Create buffer variables to cache column lists
    " let b:IN_sql_mru_tbl_incl = ''
    " let b:IN_sql_mru_tbl_excl = ''

    return 1
endfunction

function! s:IN_SyntaxList( group_name, icon_id )
    let saveL = @l
    
    " Generate (based on the syntax highlight rules) a list of
    " the Statements, functions, keywords and so on available
    " If this needs updating, the syntax\sql.vim file should be
    " updated
    redir @l
    silent! exec 'syntax list ' . a:group_name
    redir END

    if @l !~ 'E28'
        let syn_list = substitute( @l, '^.*xxx\s*', 
                    \ (a:icon_id!=''?(a:icon_id):'18').":", '' )
        let syn_list = substitute( syn_list, '\s*links to.*$', '', '' )
        let syn_list = substitute( syn_list, "[\n]", ' ', 'g' )
        let syn_list = substitute( syn_list, '\s*\_$', '', '' )
        let syn_list = substitute( syn_list, '\s\+', "\n".
                    \ (a:icon_id!=''?(a:icon_id):'18').":", 'g' )
    else
        let syn_list = ''
    endif

    let @l = saveL

    return syn_list
endfunction

function! s:IN_CreateVimHelper( vistype )
    if( &filetype == 'sql' )
        " If any work has to happen prior to calling the DLL
        " this should be done here.
        " In this case, we need to populate the VimHelper.txt file
        " so that the DLL knows what to display.
        return s:IN_CreateVimHelperSQL( a:vistype )
    endif

    return
endfunction

function! s:IN_CreateVimHelperSQL( vistype )

    " If this function returns -1, then insenvim.exe will
    " not be called, this allows us to make configuration
    " changes without the penalty of a system call.
    
    " These features require special additions to the
    " 2.02 version of dbext.vim
    " http://vim.sourceforge.net/script.php?script_id=356
    if a:vistype == 'GetTableList' ||
                \ a:vistype == 'GetProcedureList' ||
                \ a:vistype == 'GetViewList' ||
                \ a:vistype == 'GetColumnList'
        if !exists('g:loaded_dbext')
            let msg = "The dbext plugin must be loaded for this feature"
            call IN_ErrorMsg(msg)
            return
        elseif g:loaded_dbext < 210
            let msg = "The dbext plugin must be at least version 2.10 " .
                        \ " for this feature"
            call IN_ErrorMsg(msg)
            return
        endif
    endif
    
    if a:vistype == 'GetTableList'
        return DB_getDictionaryName( 'Table' )
    elseif a:vistype == 'GetProcedureList'
        return DB_getDictionaryName( 'Procedure' )
    elseif a:vistype == 'GetViewList'
        return DB_getDictionaryName( 'View' )
    elseif a:vistype == 'ResetColumnCache'
        let table_name   = expand("<cword>")
        " This is called from multiple places
        call s:IN_SQL_ClearTblColCache(table_name)
        return -1
    elseif a:vistype == 'ResetAllColumnCache'
        " this is called from multiple places
        call s:IN_SQL_ClearTblColCache('')
        return -1
    elseif a:vistype == 'GetColumnList'
        let table_name   = expand("<cword>")

        " Check to see if this mapping was called by the 
        " user pressing '.'.  Otherwise expand("<cword>") can
        " pick up the wrong word
        if getline('.')[col('.')-2] == '.'
            let table_name = '.'
        endif

        let table_cols = s:IN_SQL_GetColumns(table_name)

        " Workaround a Vim bug, where the output would be offset in the
        " file
        silent! echo "\n"
        exe 'redir! > ' . s:IN_sql_cols_file 
        silent echo table_cols
        redir END

        return s:IN_sql_cols_file
    endif

    return ''
endfunction

function! s:IN_DestroyVimHelper()
    return
endfunction

function! s:IN_DestroyVimHelperSQL()
    return
endfunction

function! s:IN_SQL_ExecCmd( name, ... )
    let result = '\n'
    
    if a:name == 'describeTable'
        let result = substitute(DB_execCmd('describeTable', a:1), "\n", "<BR>", 'g')
        if result == '-1'
            let result = ''
        endif
    elseif a:name == 'describeProcedure'
        let result = substitute(DB_execCmd('describeProcedure', a:1), "\n", "<BR>", 'g')
        if result == '-1'
            let result = ''
        endif
    elseif a:name == 'getTableList'
        let result = DB_getDictionaryName( 'Table' )
    elseif a:name == 'getListColumn'
        let result = s:IN_SQL_GetColumns(a:1)
    endif

    return result
endfunction

function! s:IN_SQL_GetColumns(table_name)
    let table_name   = a:table_name
    let table_cols   = "\n"
    let table_alias  = ''
    let move_to_top  = 1

    if g:loaded_dbext >= 210
        let saveSettingAlias = DB_listOption('use_tbl_alias')
        exec 'DBSetOption use_tbl_alias=n'
    endif

    " Ensure MRU lists are initialized
    call s:IN_SQL_MRUInit( 'b:IN_sql_mru_tbl_excl' )
    call s:IN_SQL_MRUInit( 'b:IN_sql_mru_tbl_incl' )

    if table_name == '.'
        let saveY      = @y
        let saveSearch = @/
        let curline    = line(".")
        let curcol     = col(".")

        " If . was entered, look at the word just before the .
        " We are looking for something like this:
        "    select * 
        "      from customer c
        "     where c.
        " So when . is pressed, we need to find 'c'
        "
        " strpart, returns the entire line up to (but not including)
        " the '.'.
        " matchstr, returns the last word on the line
        let table_name = matchstr(
                    \ strpart(getline('.'), 0, col('.')-2),
                    \ '\w\+$'
                    \ )

        if s:IN_SQL_MRUHas( 'b:IN_sql_mru_tbl_excl',
                    \ ':\('.table_name.'\|'.table_name.'\):' ) > -1
            " Table is part of the exlude list
            return -1
        endif 

        let table_cols = s:IN_SQL_MRUGet( 'b:IN_sql_mru_tbl_incl',
                    \ ':\('.table_name.'\|'.table_name.'\):', move_to_top )

        if table_cols == -2 
            " The table is not in the MRU
            " Since this could potentially be an table alias, 
            " check the statement for the fullname

            " Search backwards and do NOT wrap
            exec 'silent! normal! v?\<\(select\|update\|delete\|;\)\>'."\n".'"yy'

            let query = @y
            let query = substitute(query, "\n", ' ', 'g')

            " if query =~? '^\(select\|update\|delete\)'
            if query =~? '^\(select\)'
                "  \(\(\<\w\+\>\)\.\)\?   - 
                " 'from.\{-}'  - Starting at the from clause
                " '\zs\(\(\<\w\+\>\)\.\)\?' - Get the owner name (optional)
                " '\<\w\+\>\ze' - Get the table name 
                " '\s\+\<'.table_name.'\>' - Followed by the alias
                " '\s*\.\@!.*'  - Cannot be followed by a .
                " '\(\<where\>\|$\)' - Must be followed by a WHERE clause
                " '.*'  - Exclude the rest of the line in the match
                let table_name_new = matchstr(@y, 
                            \ 'from.\{-}'.
                            \ '\zs\(\(\<\w\+\>\)\.\)\?'.
                            \ '\<\w\+\>\ze'.
                            \ '\s\+\%(as\s\+\)\?\<'.table_name.'\>'.
                            \ '\s*\.\@!.*'.
                            \ '\(\<where\>\|$\)'.
                            \ '.*'
                            \ )
                if table_name_new != ''
                    let table_alias = table_name
                    let table_name  = table_name_new
                endif
            else
                " Not a SQL statement, do not display a list
                return -1
            endif

            let @y = saveY
            let @/ = saveSearch

            " Return to previous location
            call cursor(curline, curcol)
        else
            let table_cols = s:IN_SQL_GetColsFromElement(table_cols)
        endif

    else
        if s:IN_SQL_MRUHas( 'b:IN_sql_mru_tbl_excl',
                    \ ':\('.table_name.'\|'.table_name.'\):' ) > -1
            " Table is part of the exlude list
            return -1
        endif 

        let table_cols = s:IN_SQL_MRUGet( 'b:IN_sql_mru_tbl_incl',
                    \ ':\('.table_name.'\|'.table_name.'\):', move_to_top )

        let table_cols = s:IN_SQL_GetColsFromElement(table_cols)
    endif

    if table_cols == '-2' || table_cols == ''
        " Specify silent mode, no messages to the user (tbl, 1)
        " Specify do not comma separate (tbl, 1, 1)
        let table_cols = DB_getListColumn(table_name, 1, 1)

        if table_cols == '' || table_cols == -1
            call s:IN_SQL_MRUAdd( 'b:IN_sql_mru_tbl_excl',
                    \ ':'.table_name.':'.table_alias.':-1:' ) 
        else
            " The VimHelper.txt file must have extra blank lines
            " at the end.  It ignores these, so you can have as 
            " many as you need.  This ensures there are enough
            " to display the output correctly.
            let table_cols = table_cols . "\n\n"
            call s:IN_SQL_MRUAdd( 'b:IN_sql_mru_tbl_incl',
                    \ ':'.table_name.':'.table_alias.':'.table_cols.':' )
        endif

        if g:loaded_dbext > 201
            exec 'DBSetOption use_tbl_alias='.saveSettingAlias
        endif
    endif

    return table_cols
endfunction

function! s:IN_SQL_GetColsFromElement(element)
    return substitute( a:element, '.*:\(.*\):$', '\1', '' ) 
endfunction

function! s:IN_SQL_ClearTblColCache(tbl_name)

    if a:tbl_name == ''
        call s:IN_SQL_MRUReset('b:IN_sql_mru_tbl_incl')
        call s:IN_SQL_MRUReset('b:IN_sql_mru_tbl_excl')
    else
        let strip_element = 0
        let table_cols = s:IN_SQL_MRUGet( 'b:IN_sql_mru_tbl_incl',
                    \ ':\('.a:tbl_name.'\|'.a:tbl_name.'\):', strip_element )
        
        let table_cols = s:IN_SQL_MRUGet( 'b:IN_sql_mru_tbl_excl',
                    \ ':\('.a:tbl_name.'\|'.a:tbl_name.'\):', strip_element )
       
    endif

    return
endfunction

function! s:IN_SQL_MRUInit( mru_list )

    " Create the list if required
    if !exists('{a:mru_list}')
        let {a:mru_list} = ''
        return 1
    endif

    return 0
endfunction

function! s:IN_SQL_MRUReset( mru_list )

    " Verify the list exists
    if !exists('{a:mru_list}')
        return -1
    else
        let {a:mru_list} = ''
    endif

    return 1
endfunction

function! s:IN_SQL_MRUHas( mru_list, find_str )

    " The MRU list has elements of this format:
    "  :tbl_name:tbl_alias:tbl_cols:#
    "  :tbl_name:tbl_alias:tbl_cols:#
    "
    " This function will find a string and return the element #

    if !exists('{a:mru_list}')
        return '-3'
    endif

    let find_idx = match({a:mru_list}, a:find_str)
    " Decho 'Get-'.a:find_str.'  find_idx:'.find_idx

    if find_idx == -1 
        return -1
    endif

    let end_idx = match({a:mru_list}, '#', find_idx+1)

    let curr_cnt = strlen(
                \     substitute(
                \         strpart({a:mru_list}, 0, end_idx+1), 
                \     '[^#]', '', 'g')
                \ )
        
    return curr_cnt

endfunction

function! s:IN_SQL_MRUGet( mru_list, find_str, move_to_top )

    " The MRU list has elements of this format:
    "  :tbl_name:tbl_alias:tbl_cols:#
    "  :tbl_name:tbl_alias:tbl_cols:#
    "
    " This function will find a string and return:
    "  :tbl_name:tbl_alias:tbl_cols:
    "
    " It will also remove that element from the list
    " Use the Add function to put it back on the TOP of the list

    if !exists('{a:mru_list}')
        return '-3'
    endif

    let find_idx = match({a:mru_list}, a:find_str)
    " Decho 'Get-'.a:find_str.'  find_idx:'.find_idx

    if find_idx == -1 
        return '-2'
    endif

    let end_idx = match({a:mru_list}, '#', find_idx+1)
    " Decho 'Get-end_idx-'.end_idx

    if end_idx != -1
        let element = substitute( strpart({a:mru_list}, 0, end_idx+1),
                    \ '.*\(:.*:.*:.*:\)#$', '\1', '' ) 
        let text_before = strpart({a:mru_list}, 0, (end_idx-strlen(element)))
        let text_after = strpart({a:mru_list}, end_idx+1)
        " Decho 'G-before-'.strpart({a:mru_list}, 0, (end_idx-strlen(element)))
        " Decho 'G-middle-'.element
        " Decho 'G-after-'.strpart({a:mru_list}, end_idx+1)

        if a:move_to_top == 1
            let {a:mru_list} = element . '#' . text_before . text_after
        else
            let {a:mru_list} = text_before . text_after
        endif

        " Decho "Get-new-#".{a:mru_list}

        return element
    endif
        
    " String now found
    return '-2'

endfunction

function! s:IN_SQL_MRUAdd( mru_list, element )

    " Allow (retain) only IN_sql_mru_max in the MRU list. Remove/discard
    " the remaining entries. As we are adding a one entry to the list,
    " the list should have only g:IN_sql_mru_max - 1 in it.
    let curr_cnt = strlen(substitute({a:mru_list}, '[^#]', '', 'g'))
    " Decho 'A-items-'.curr_cnt

    " If the list is already full, drop the last element from the list
    if curr_cnt == g:IN_sql_mru_max
        " Decho "A-old_list-#".{a:mru_list}."\n"
        " Strip off the last element from the list
        let {a:mru_list} = substitute({a:mru_list}, 
                    \ '\(.*\):.*:.*:.*:#$', '\1', '' ) 
        " Decho "A-new_list-#".{a:mru_list}."\n"
    endif

    " Add the new filename to the beginning of the MRU list
    let {a:mru_list} = a:element.'#'.{a:mru_list}
    " Decho "A-new-#".{a:mru_list}

    return 1
endfunction

" Check if the line is a comment
function! s:IN_IsLineComment(lnum)
    let rc = synIDattr(
                \ synID(a:lnum, 
                \     match(getline(a:lnum), '\S')+1, 0)
                \ , "name") 
                \ =~? "comment" 

    return rc
endfunction


" Check if the column is a comment
function! s:IN_IsColComment(lnum, cnum)
    let rc = synIDattr(synID(a:lnum, a:cnum, 0), "name") 
                \           =~? "comment" 

    return rc
endfunction

" build menu system

function! s:ShowConfiguration()

	let conf = "Intellisense Version : " . g:intellisense_version . "\n"
	let conf = conf . "-----------------------------------------------------\n"
	let conf = conf . " Environment\n"
	let conf = conf . "   VIM : " . expand('$VIM') . "\n"
	let conf = conf . "   HOME : " . expand('$HOME') . "\n"
	let conf = conf . "   VIM_INTELLISENSE : " . expand('$VIM_INTELLISENSE') . "\n"
	let conf = conf . "   intellisense_root_dir : " . g:intellisense_root_dir . "\n"
	let conf = conf . "   temp directory : " . g:tmpdir . "\n"

    let conf = conf . "   using " . s:intellisense_plugin . "\n"

	let conf = conf . " ----------------------------------------------------------\n"
	let conf = conf . " DEFAULTS\n"
	let conf = conf . "  doc help delay     : " . s:dochelpdelay . "\n"
	let conf = conf . "  ignore keys        : " . s:ignorekeys . "\n"
	let conf = conf . "  delimeter key      : " . s:delimiterkey . "\n"
	let conf = conf . "  tool tip close key : " . s:tooltipclosekey . "\n"
	let conf = conf . "  ignorecase         : " . s:ignorecase . "\n"
	let conf = conf . "-----------------------------------------------------\n"

	call confirm(conf, "&OK", 1, "Info")
endfunction

"" build the gui menu
if has("gui_running")

	set mousemodel=popup
	silent! aunmenu &Intellisense
	silent! tunmenu &Intellisense
	amenu &Intellisense.&Show\ Configuration :call <SID>ShowConfiguration()<CR>
	tmenu &Intellisense.Show\ Configuration Show the current values of the Intellisense Enironment
	amenu &Intellisense.-File\ Type\ Plugins\ After\ This-  : <NOP>

endif

" }}}

augroup au_intellisense
	au!
	autocmd BufUnload * call s:IN_DestroyVimHelper()
augroup END


" vim:fdm=marker:nowrap:ts=4:
