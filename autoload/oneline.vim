vim9script

import './oneline/default.vim'
import autoload './statusline.vim' as SL

# 保存当前插件状态
final status: dict<bool> = {'enabled': false, 'initialized': false}

export def Enable()
    # 更改插件状态
    status.enabled = true
    # 初始化
    Init()
    # 更新窗口状态栏
    Update()
    # 设置自动命令
    AutoCmd()
enddef

export def Disable()
    # 更改插件状态
    status.enabled = false
    # 复位 statusline 选项
    set statusline=
    # 删除自动命令组
    AutoCmdRemove()
enddef

def Init()
    if status.initialized
        finish
    endif
    # 更改初始化状态
    status.initialized = true
    # 新建/获取全局配置
    if !exists('g:oneline')
        g:oneline = {}
    endif
    # 合并插件自定义配置
    MergeConfig()
    # echom config
enddef

def MergeConfig(): dict<any>
    # 原地修改
    g:oneline->extend(default.preset, 'keep')
    return g:oneline
enddef


# 用户无法直接调用 Update()，且由 Enable() 首次调用
export def Update()
    if !status.enabled  # 插件处于关闭状态
        finish
    endif
    var win_id = winnr()
    var win_count = winnr('$')
    # 为当前窗口和其它窗口设置不同的状态栏
    var Statusline = function(SL.Statusline, [MergeConfig()])
    var statusline: list<string> = win_count == 1 && win_id > 0
        ? [Statusline(v:true)]
        : [Statusline(v:true), Statusline(v:false)]
    for i in range(1, win_count)
        setwinvar(i, '&statusline', i == win_id 
            ? statusline[0] 
            : statusline[1])
    endfor
enddef

def AutoCmd()
    augroup oneline
        autocmd!
        autocmd WinEnter,BufEnter,SessionLoadPost,FileChangedShellPost * Update()
    augroup END
enddef

def AutoCmdRemove()
    augroup oneline
        autocmd!
    augroup END
    augroup! oneline
enddef
