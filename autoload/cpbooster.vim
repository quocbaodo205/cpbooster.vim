let s:cpboosterWindowRatio = 3.0 / 7.0

execute 'autocmd TermClose * wincmd w'

if (has('nvim'))
  let s:termCommand = 'botright vsplit | term '
else
  let s:termCommand = 'vert botright term '
endif

function cpbooster#DeleteTerminalBuffers()
  if (has('nvim'))
    let pattern = '.*term:.*cpbooster.*'
  else
    let pattern = '!cpbooster.*'
  endif

  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && bufname(v:val) =~ "'.pattern.'"')
  if (len(buffers) > 0)
      exe 'bd! '.join(buffers, ' ')
  endif
endfunction

function cpbooster#startInsert(...)
  if (has('nvim'))
    execute 'startinsert'
  endif
endfunction

function cpbooster#CpboosterTest(...)
  execute 'w'
  call cpbooster#DeleteTerminalBuffers()
  let totalSize = winwidth(0)
  if a:0 == 0
    execute s:termCommand . 'cpbooster test "%" && read'
  else
    execute s:termCommand . 'cpbooster test "%" -t ' . a:1	. ' && read'
  endif
  call cpbooster#startInsert()
  execute 'vertical resize ' . string(totalSize * s:cpboosterWindowRatio) 
endfunction

function cpbooster#CpboosterDebug(...)
  execute 'w'
  call cpbooster#DeleteTerminalBuffers()
  let totalSize = winwidth(0)
  if a:0 == 0
    execute s:termCommand . 'cpbooster test "%" -d && read'
  else
    execute s:termCommand . 'cpbooster test "%" -d -t ' . a:1 . ' && read'
  endif
  call cpbooster#startInsert()
  execute 'vertical resize ' . string(totalSize * s:cpboosterWindowRatio) 
endfunction

function cpbooster#CpboosterRDebug(...)
  execute 'w'
  call cpbooster#DeleteTerminalBuffers()
  let totalSize = winwidth(0)
  if a:0 == 0
    execute s:termCommand . 'cpbooster test "%" -d --nc && read'
  else
    execute s:termCommand . 'cpbooster test "%" -d --nc -t ' . a:1 . ' && read'
  endif
  call cpbooster#startInsert()
  execute 'vertical resize ' . string(totalSize * s:cpboosterWindowRatio) 
endfunction

function cpbooster#CpboosterRTest(...)
  execute 'w'
  call cpbooster#DeleteTerminalBuffers()
  let totalSize = winwidth(0)
  if a:0 == 0
    execute s:termCommand . 'cpbooster test "%" --nc && read'
  else
    execute s:termCommand . 'cpbooster test "%" --nc -t ' . a:1	. ' && read'
  endif
  call cpbooster#startInsert()
  execute 'vertical resize ' . string(totalSize * s:cpboosterWindowRatio) 
endfunction

function cpbooster#CpboosterAddtc(...)
  execute 'w'
  call cpbooster#DeleteTerminalBuffers()
  let tcFilePaths = systemlist('cpb stat ' . expand("%") . ' --nextTestCaseFilePaths')
  if (len(tcFilePaths) == 2) "since version 2.3.0 of cpbooster
    "<filePath>.ans#
    execute 'botright vnew ' . tcFilePaths[1]
    "<filePath>.in#
    execute 'leftabove new ' . tcFilePaths[0]
  else
    let totalSize = winwidth(0)
    execute s:termCommand . 'cpbooster test "%" -a'
    if (has('nvim'))
      execute 'startinsert'
    endif
    execute 'vertical resize ' . string(totalSize * s:cpboosterWindowRatio) 
  endif
endfunction

function cpbooster#CpboosterCreate(...)
  execute 'w'
  if a:0 == 1
    execute '!cpbooster create ' . a:1
    execute 'e ' . a:1
  else
    echo 'Missing file name'
  endif
endfunction

function cpbooster#CpboosterSubmit(...)
  execute 'w'
  call cpbooster#DeleteTerminalBuffers()
  let totalSize = winwidth(0)
  if a:0 == 1
    execute s:termCommand . 'cpbooster submit "%" ' . a:1
  else
    execute s:termCommand . 'cpbooster submit "%"'
  endif
  call cpbooster#startInsert()
  execute 'vertical resize ' . string(totalSize * s:cpboosterWindowRatio) 
endfunction
