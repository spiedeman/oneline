vim9script

import './oneline/default.vim'
# import autoload './statusline.vim'

# final SL = statusline.Statusline

class Oneline
    var status: dict<bool>
    var default_config: dict<any>
    var status_line: list<string>

    def new()
        this.status.enabled = v:false
        this.status.initialized = v:false
        this.default_config = default.Default.preset
    enddef

    def Enable()
        # echom this.status
        # 更改插件状态
        this.status.enabled = true
        # 初始化
        this.Init()
        # 更新窗口状态栏
        this.Update()
        # 设置自动命令
        # AutoCmd()
    enddef

    def Disable()
        # 更改插件状态
        this.status.enabled = false
        # 复位 statusline 选项
        # set statusline=
        for i in range(1, winnr('$'))
            setwinvar(i, '&statusline', '')
        endfor
        # 删除自动命令组
        # AutoCmdRemove()
    enddef

    def Init()
        if this.status.initialized
            finish
        endif
        # 更改初始化状态
        this.status.initialized = true
        # 新建/更新全局配置
        if !exists('g:oneline')
            g:oneline = {}
        endif
        # 合并插件自定义配置
        this.MergeConfig()
    enddef

    def MergeConfig()
        # 原地修改
        if exists('g:oneline')
            g:oneline -> extend(this.default_config, 'keep')
        endif
    enddef


    # 用户无法直接调用 Update()，且由 Enable() 首次调用
    def Update()
        if !this.status.enabled  # 插件处于关闭状态
            finish
        endif
        var win_id = winnr()
        var win_count = winnr('$')
        # 为当前窗口和其它窗口设置不同的状态栏
        this.MergeConfig()

        this.status_line = win_count == 1 && win_id > 0
            ? ['%{%statusline#Statusline.Set(g:oneline, v:true)%}']
            : ['%{%statusline#Statusline.Set(g:oneline, v:true)%}', '%{%statusline#Statusline.Set(g:oneline, v:false)%}']
        for i in range(1, win_count)
            setwinvar(i, '&statusline', i == win_id 
                ? this.status_line[0] 
                : this.status_line[1])
        endfor
    enddef
endclass

var OL = Oneline.new()

export def Enable()
    OL.Enable()
    AutoCmd()
enddef

export def Disable()
    OL.Disable()
    AutoCmdRemove()
enddef

export def Update()
    OL.Update()
enddef

def AutoCmd()
    augroup oneline
        autocmd!
        autocmd WinEnter,BufEnter,SessionLoadPost,FileChangedShellPost * OL.Update()
    augroup END
enddef

def AutoCmdRemove()
    augroup oneline
        autocmd!
    augroup END
    augroup! oneline
enddef
