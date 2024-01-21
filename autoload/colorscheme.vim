vim9script

import autoload './themes/solarized.vim' as default
const default_theme: dict<any> = default.theme

def HlGroupNotValid(hlname: string): bool
    var query: list<any> = hlget(hlname)
    return !query || (query[0] -> has_key('cleared') && query[0]['cleared'])
enddef

def SetHighlightGroup(theme: dict<any>)
    # For Sections
    for [sec_l, sec_r] in {'a': 'z', 'b': 'y', 'c': 'x'} -> items()
        for is_active in [v:true, v:false]
            for mode in ['normal', 'insert', 'visual', 'replace']
                var hlname_l: string = $'Oneline_{is_active ? "active" : "inactive"}_{is_active ? mode .. "_" : ""}{sec_l}'
                var hlname_r: string = $'Oneline_{is_active ? "active" : "inactive"}_{is_active ? mode .. "_" : ""}{sec_r}'
                var hlgroup: dict<any> = (is_active
                    ? mode == 'normal' ? theme.normal[sec_l] : theme[mode]
                    : theme.inactive[sec_l])
                    -> extendnew({'name': hlname_l})
                if HlGroupNotValid(hlname_l)
                    hlset([hlgroup])
                    hlset([{'name': hlname_r, 'linksto': hlname_l}])
                endif
            endfor
        endfor
    endfor
    # For Separators
    for [sec_l, sec_r] in [['b', 'y'], ['c', 'x']]
        for is_active in [v:true, v:false]
            for mode in ['normal', 'insert', 'visual', 'replace']
                var hlname_l: string = $'Oneline_{is_active ? "active" : "inactive"}_{is_active ? mode .. "_" : ""}a_{sec_l}'
                var hlname_r: string = $'Oneline_{is_active ? "active" : "inactive"}_{is_active ? mode .. "_" : ""}z_{sec_r}'
                var hlgroup: dict<any> = {'name': hlname_l}
                    -> extendnew({'guibg': is_active ? theme.normal[sec_l].guibg : theme.inactive[sec_l].guibg})
                    -> extendnew({'guifg': is_active
                        ? mode == 'normal' ? theme.normal.a.guibg : theme[mode].guibg
                        : theme.inactive.a.guibg})
                if HlGroupNotValid(hlname_l)
                    hlset([hlgroup])
                    hlset([{'name': hlname_r, 'linksto': hlname_l}])
                endif
            endfor
        endfor
    endfor
    for [sec_l, sec_r] in [['b', 'y'], ['c', 'x']]
        for is_active in [v:true, v:false]
            var hlname_l: string = $'Oneline_{is_active ? "active" : "inactive"}_{is_active ? "normal" .. "_" : ""}{sec_l}_c'
            var hlname_r: string = $'Oneline_{is_active ? "active" : "inactive"}_{is_active ? "normal" .. "_" : ""}{sec_r}_x'
            var hlgroup: dict<any> = {'name': hlname_l}
                -> extendnew({'guifg': is_active ? theme.normal[sec_l].guibg : theme.inactive[sec_l].guibg})
                -> extendnew({'guibg': is_active ? theme.normal.c.guibg : theme.inactive.c.guibg})
            if HlGroupNotValid(hlname_l)
                hlset([hlgroup])
                hlset([{'name': hlname_r, 'linksto': hlname_l}])
            endif
        endfor
    endfor
enddef


def LinkSectionColor(mode: string)
    # active
    for [sec_l, sec_r] in {'b': 'y', 'c': 'x'} -> items()
        hlset([{'name': $'Oneline_active_{sec_l}', 'linksto': $'Oneline_active_normal_{sec_l}'}])
        hlset([{'name': $'Oneline_active_{sec_r}', 'linksto': $'Oneline_active_normal_{sec_r}'}])
    endfor
    
    if default_theme -> has_key(mode->tolower())
        hlset([{'name': 'Oneline_active_a', 'linksto': $'Oneline_active_{mode}_a'}])
        hlset([{'name': 'Oneline_active_z', 'linksto': $'Oneline_active_{mode}_z'}])
    else
        hlset([{'name': 'Oneline_active_a', 'linksto': 'Oneline_active_normal_a'}])
        hlset([{'name': 'Oneline_active_z', 'linksto': 'Oneline_active_normal_z'}])
    endif
    hlset([{'name': 'Oneline_Middle', 'linksto': 'Oneline_active_c'}])
enddef

def LinkSepratorColor(mode: string)
    # active
    var hlname_l: string
    var hlname_r: string
    var hlname_l_t: string
    var hlname_r_t: string
    for [sec_l, sec_r] in [['b', 'y'], ['c', 'x']]
        hlname_l = $'Oneline_active_a_{sec_l}'
        hlname_r = $'Oneline_active_z_{sec_r}'
        if default_theme -> has_key(mode->tolower())
            hlname_l_t = $'Oneline_active_{mode}_a_{sec_l}'
            hlname_r_t = $'Oneline_active_{mode}_z_{sec_r}'
        else
            hlname_l_t = $'Oneline_active_normal_a_{sec_l}'
            hlname_r_t = $'Oneline_active_normal_z_{sec_r}'
        endif
        hlset([{'name': hlname_l, 'linksto': hlname_l_t}])
        hlset([{'name': hlname_r, 'linksto': hlname_r_t}])
    endfor
    for [sec_l, sec_r] in [['b', 'y'], ['c', 'x']]
        hlname_l = $'Oneline_active_{sec_l}_c'
        hlname_r = $'Oneline_active_{sec_r}_x'
        hlname_l_t = $'Oneline_active_normal_{sec_l}_c'
        hlname_r_t = $'Oneline_active_normal_{sec_r}_x'
        hlset([{'name': hlname_l, 'linksto': hlname_l_t}])
        hlset([{'name': hlname_r, 'linksto': hlname_r_t}])
    endfor
    for [sec_l, sec_r] in {'a': 'z', 'b': 'y', 'c': 'x'} -> items()    
        for is_active in [v:true, v:false]
            hlname_l = $'Oneline_{is_active ? "active" : "inactive"}_{sec_l}_m'
            hlname_r = $'Oneline_{is_active ? "active" : "inactive"}_{sec_r}_m'
            hlname_l_t = $'Oneline_{is_active ? "active" : "inactive"}_{sec_l}_c'
            hlname_r_t = $'Oneline_{is_active ? "active" : "inactive"}_{sec_r}_x'
            hlset([{'name': hlname_l, 'linksto': hlname_l_t}])
            hlset([{'name': hlname_r, 'linksto': hlname_r_t}])
        endfor
    endfor
enddef

export def Link(mode: string)
    SetHighlightGroup(default_theme)
    LinkSectionColor(mode)
    LinkSepratorColor(mode)
enddef

export def GetSecHlGroup(is_active: bool, section: string): string
    return $'Oneline_{is_active ? "active" : "inactive"}_{section}'
enddef

export def GetSepHlGroup(is_active: bool, sections: list<string>): string
    return $'Oneline_{is_active ? "active" : "inactive"}_{sections[0]}_{sections[1]}'
enddef
