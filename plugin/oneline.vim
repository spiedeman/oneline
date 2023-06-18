vim9script

if exists('g:loaded_oneline') || v:version < 802
    finish
endif

import autoload 'oneline.vim'

if v:vim_did_enter
    # 适用于延迟到 VimEnter 事件之后加载
    oneline.Enable()
else
    augroup oneline_enter
        autocmd!
        autocmd VimEnter * ++once oneline.Enable() 
    augroup END
endif

g:loaded_oneline = 1
