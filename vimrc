" Loeschen eventuell vorhandener Autocommands
autocmd! 

set nocompatible
behave mswin
set selectmode=mouse
set tabstop=4

" Indent von 3 Zeichen, diese werden beibehalten
set shiftwidth=4
set shiftround
set autoindent 

" Cursorposition anzeigen
"set ruler

" Farbschema
set background=dark
colorscheme solarized

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Kommandohistory auf 50 Zeilen setzen
set history=4000

" Commandline Completion mit <Tab>
set wildmode=list:longest,full

" Aktuellen Modus anzeigen
"set showmode
"set showcmd 

"Kontext rund um den Cursor anzeigen
set scrolloff=10

" Zeilennummern anzeigen
set nu 

if has("multi_byte")
    set encoding=utf-8
    setglobal fileencoding=utf-8
    " set bomb
" set termencoding=utf-8,iso-8859-15
" set fileencodings=utf-8,iso-8859-15
    set termencoding=utf-8
    set fileencodings=utf-8
else
  echoerr "Diese Version von Vim wurde nicht mit +multi_byte kompiliert!"
endif 

" allow backspacing over everything in insert mode
set backspace=1
set autoindent		" always set autoindenting on

" Aktivieren der Dateityperkennung
filetype on
filetype indent on
filetype plugin on 

" Inkrementelle Suche
set incsearch

" Suche ist nicht case-sensitiv, ausser der Begriff beinhaltet
" Grossbuchstaben
set ignorecase
set smartcase 

if has("win32")
	set guifont=Bitstream_Vera_Sans_Mono:h12
	set dir=d:\temp
	set bdir=d:\temp
	set nobackup
	set writebackup
	
	" In Vim, the unnamed register is the " register, and the Windows
	" Clipboard is the * register. This means that if you yank something,
	" you have to yank it to the * register if you want to paste it into
	" a Windows app. If this is too much trouble, set the 'clipboard' 
	" option to 'unnamed'. Then you always yank to *.
	set clipboard=unnamed
	" For Win32 version, have "K" lookup the keyword in a help file
	let winhelpfile='windows.hlp'
	map K :execute "!start winhlp32 -k <cword> " . winhelpfile <CR>
else
	set bdir=$HOME/tmp
	set dir=$HOME/tmp
	set nobackup
	set writebackup
	set guifont=DejaVu\ Sans\ Mono\ 12
endif

set diffopt=horizontal
"set cursorline
"set cursorcolumn
set spelllang=de_at,en

" ======================================================================
" For blogging
" Fladert from: http://www.vmunix.com/vim/source/html.vim (Sven Guckes)
" insert "generic link"
  iab  Yhref <a href="" title=""></a><ESC>?""<CR>a
  vmap ,href "zdi<a href="" title="<C-R>z"><C-R>z</a><ESC>F"i
  vmap ,HREF "zdi<a href="<C-R>z" title=""></a><ESC>F"i
"
" make current URL a link:
  vmap ,link "zdi<a href="<C-R>z"<C-M><C-I>><C-R>z</a><ESC>F"i
"
" add link to current text:
" vmap ,text "zdi<a href="" title=""><C-R>z</a><ESC>F"i
  vmap ,text "zdi<a href="" title=""><C-R>z</a><ESC>F"i
 
" Create a legal filename from the first line of the file and copy it into to
" the OS-clipboard by ways of copying it to the last line of the file

map <F8> <ESC>gg"fYG"fpG<ESC>:s/\s/_/gie<CR><ESC>:s:ä:ae:eg<CR><ESC>:s:Ä:AE:ge<CR><ESC>:s:ö:oe:ge<CR><ESC>:s:Ö:OE:ge<CR><ESC>:s:ü:ue:ge<CR><ESC>:s:Ü:UE:ge<CR><ESC>:s:ß:sz:ge<CR><ESC>:s/@/-at-/ge<CR><ESC>:s:_-_:-:ge<CR><ESC>:s:-_:-:ge<CR><ESC>:s:_-:-:ge<CR><ESC>:s/\:_/-/ge<CR><ESC>:s:?::ge<CR><ESC>:s:\"::ge<CR><ESC>:s:\'::ge<CR><ESC>:s/\!//ge<CR><ESC>:s/(//ge<CR><ESC>:s/)//ge<CR><ESC>:s/\.//ge<CR><ESC>:s:,_:_:ge<CR><ESC>:s:_$::e<CR><ESC>A.txt<ESC>"+dd:browse confirm wa<CR>

map <F9> <ESC>iTITEL<CR>meta-Author: <a rel="author" href="/static/about-me.html">Martin Leyrer</a><CR>Tags: <CR><CR><ESC>

" http://vim.wikia.com/wiki/HTML_entities
" If you add this code to your vimrc, you can escape visually-selected HTML with ctrl-h, and unescape with ctrl-u. 
function HtmlEscape()
  silent s/&/\&amp;/eg
  silent s/</\&lt;/eg
  silent s/>/\&gt;/eg
endfunction

function HtmlUnEscape()
  silent s/&lt;/</eg
  silent s/&gt;/>/eg
  silent s/&amp;/\&/eg
endfunction

map <silent> <c-h> :call HtmlEscape()<CR>
map <silent> <c-u> :call HtmlUnEscape()<CR>



" ======================================================================
" FOLDING FUER PERL
let perl_fold=1 

fun! Pretty ()
        execute '%!perltidy -q'
endfun
nmap <silent> <C-p> <Esc>:call Pretty()<CR>

"-------------- word count ---------------
" from http://stackoverflow.com/questions/114431/fast-word-count-function-in-vim/120386#120386

"returns the count of how many words are in the entire file excluding the current line
"updates the buffer variable Global_Word_Count to reflect this
fu! OtherLineWordCount()
    let data = []
    "get lines above and below current line unless current line is first or last
    if line(".") > 1
        let data = getline(1, line(".")-1)
    endif
    if line(".") < line("$")
        let data = data + getline(line(".")+1, "$")
    endif
    let count_words = 0
    let pattern = "\\<\\(\\w\\|-\\|'\\)\\+\\>"
    for str in data
        let count_words = count_words + NumPatternsInString(str, pattern)
    endfor
    let b:Global_Word_Count = count_words
    return count_words
endf    

"returns the word count for the current line
"updates the buffer variable Current_Line_Number
"updates the buffer variable Current_Line_Word_Count
fu! CurrentLineWordCount()
    if b:Current_Line_Number != line(".") "if the line number has changed then add old count
        let b:Global_Word_Count = b:Global_Word_Count + b:Current_Line_Word_Count
    endif
    "calculate number of words on current line
    let line = getline(".")
    let pattern = "\\<\\(\\w\\|-\\|'\\)\\+\\>"
    let count_words = NumPatternsInString(line, pattern)
    let b:Current_Line_Word_Count = count_words "update buffer variable with current line count
    if b:Current_Line_Number != line(".") "if the line number has changed then subtract current line count
        let b:Global_Word_Count = b:Global_Word_Count - b:Current_Line_Word_Count
    endif
    let b:Current_Line_Number = line(".") "update buffer variable with current line number
    return count_words
endf    

"returns the word count for the entire file using variables defined in other procedures
"this is the function that is called repeatedly and controls the other word
"count functions.
fu! WordCount()
    if exists("b:Global_Word_Count") == 0
        let b:Global_Word_Count = 0
        let b:Current_Line_Word_Count = 0
        let b:Current_Line_Number = line(".")
        call OtherLineWordCount()
    endif
    call CurrentLineWordCount()
    return b:Global_Word_Count + b:Current_Line_Word_Count
endf

"returns the number of patterns found in a string
fu! NumPatternsInString(str, pat)
    let i = 0
    let num = -1
    while i != -1
        let num = num + 1
        let i = matchend(a:str, a:pat, i)
    endwhile
    return num
endf

"example of using the function for statusline:
"set statusline=wc:%{WordCount()}

"-------------------------------------------


" Nice Statusline
" from Dominique Pelle, http://dominique.pelle.free.fr/.vimrc

" Function used to display syntax group.
function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

" Function used to display utf-8 sequence.
fun! ShowUtf8Sequence()
  try
    let p = getpos('.')
    redir => utfseq
    sil normal! g8
    redir End
    call setpos('.', p)
    return substitute(matchstr(utfseq, '\x\+ .*\x'), '\<\x', '0x&', 'g')
  catch
    return '?'
  endtry
endfunction

if has('statusline')
  if version >= 700
    " Fancy status line.
    set statusline =
    set statusline+=%#User1#                       " highlighting
    set statusline+=%n                             " buffer number
    set statusline+=%{'/'.bufnr('$')}\             " buffer count
    set statusline+=%#User2#                       " highlighting
    set statusline+=%-.20F                         " file name, last 20 chars, plus modified inidcator
    set statusline+=%#User1#                       " highlighting
    set statusline+=%h%m%r%w\                      " flags
    set statusline+=%{(&key==\"\"?\"\":\"encr,\")} " encrypted?
    set statusline+=%{strlen(&ft)?&ft:'none'},     " file type
    set statusline+=%{(&fenc==\"\"?&enc:&fenc)},   " encoding
    set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
    set statusline+=%{&fileformat},                " file format
    set statusline+=%{&spelllang},                 " spell language
"    set statusline+=%(%{Tlist_Get_Tagname_By_Line()}%), " Function name
    set statusline+=%{SyntaxItem()}                " syntax group under cursor
    set statusline+=%=                             " indent right
    set statusline+=%#User2#                       " highlighting
    set statusline+=%{ShowUtf8Sequence()}\         " utf-8 sequence
    set statusline+=%#User1#                       " highlighting
    set statusline+=U+%04B\                        " Unicode char under cursor
	set statusline+=§wc:%{WordCount()},  
    set statusline+=%-6.(%l/%{line('$')},%c%V%)\ %<%P           " position

    " Use different colors for statusline in current and non-current window.
    let g:Active_statusline=&g:statusline
    let g:NCstatusline=substitute(
      \                substitute(g:Active_statusline,
      \                'User1', 'User3', 'g'),
      \                'User2', 'User4', 'g')
  endif
endif

if has('autocmd')
  augroup CursorHighlight
    au!
    au WinEnter * let&l:statusline = g:Active_statusline
    au WinLeave * let&l:statusline = g:NCstatusline
  augroup END
endif

set laststatus=2

filetype plugin indent on
