vim9script

import autoload './colorscheme.vim' as Color

class StatusLine 
    var sections: list<string> = [['a', 'z'], ['b', 'y'], ['c', 'x']]
    var section_content: dict<string> = {}
    var separator_valid: dict<string> = {}
    var separator_content: dict<string> = {}
    var status_line: string = ''
    var count: number = 0

    def new()
        for sec in this.sections -> flattennew()
            if !has_key(this.section_content, sec)
                this.section_content[sec] = ''
                this.separator_content[sec] = ''
            endif
        endfor
    enddef

    def GetMode(mode: string): string
        return mode(1)[0] ==# 'c'
            ? 'normal'
            : mode -> match('REPLACE') != -1
            ? 'replace'
            : mode -> match('INSERT') != -1
            ? 'insert'
            : mode[0] == 'V' || mode[0] == 'S'
            ? 'visual'
            : 'normal'
    enddef

    def Link(component: dict<any>)
        Color.Link(this.GetMode(this.GetComponentContent(component)))
    enddef

    def GetSectionColor(is_active: bool, section: string): string
        var color: string = Color.GetSecHlGroup(is_active, section)
        return ['%#', color, '#'] -> join('')
    enddef

    def GetSepratorColor(is_active: bool, sections: list<string>): string
        var color: string = Color.GetSepHlGroup(is_active, sections)
        return ['%#', color, '#'] -> join('')
    enddef

    def SeparatorValidUpdate()
        this.separator_valid.a = !!this.section_content.b ? 'b' : !!this.section_content.c ? 'c' : 'm'
        this.separator_valid.b = !!this.section_content.c ? 'c' : 'm'
        this.separator_valid.c = 'm'
        this.separator_valid.x = 'm'
        this.separator_valid.z = !!this.section_content.y ? 'y' : !!this.section_content.x ? 'x' : 'm'
        this.separator_valid.y = !!this.section_content.x ? 'x' : 'm'
        # echom this.separator_valid
    enddef

    def GetComponentContent(component: dict<any>): string
        var content_type: any = type(component.content)
        return content_type == v:t_string
            ? component.content
            : content_type == v:t_func
            ? component.content()
            : ' '
    enddef
    
    def GetSectionContent(config: dict<any>, is_active: bool, is_left: bool, section: string): string
        var active_type: string = is_active ? 'active' : 'inactive'
        var sec_name: string = 'oneline_' .. section
        var submargin: string = config.subseparator.margin
        var subseparator: string = is_left ? config.subseparator.left : config.subseparator.right
        var result: string = deepcopy(config[active_type][sec_name])
            -> map((_, subitem): string => config.components->has_key(subitem)
                ? this.GetComponentContent(config.components[subitem])
                : '')
            -> filter((_, subitem): bool => !!subitem)
            -> map((_, subitem): string => subitem)
            -> join(submargin .. subseparator .. submargin)

        var hlname: string = this.GetSectionColor(is_active, section)
        if !!result
            # return (is_left ? [hlname .. '%(', result, '%)' .. config.separator.left]
            #                 : [hlname .. config.separator.right .. '%(', result, '%)'])
            #         -> join(config.separator.margin)
            return [hlname .. '%(', result, '%)'] -> join(config.separator.margin)
        endif
        return result
    enddef

    def GetSepratorContent(config: dict<any>, is_active: bool, is_left: bool, section: string): string
        var hlname: string = this.GetSepratorColor(is_active, [section, this.separator_valid[section]])
        var separator: string = is_left ? config.separator.left : config.separator.right
        return !!this.section_content[section] ? [hlname, separator] -> join('') : ''
    enddef

    def MergeSectionSeparatorContent(is_left: bool, section: string): string
        var sec_content: string = this.section_content[section] 
        var sep_content: string = this.separator_content[section]
        var result: string = (is_left ? [sec_content, sep_content] : [sep_content, sec_content]) -> join('')
        return result
    enddef

    def Set(config: dict<any>, active: bool): string
        this.count += 1
        # echom this.count
        # echom this.section_content
        
        for [l, r] in this.sections 
            this.section_content[l] = this.GetSectionContent(config, active, 1, l)
            this.section_content[r] = this.GetSectionContent(config, active, 0, r)
        endfor
        # echom this.separator_content
        this.Link(config.components.mode)

        this.SeparatorValidUpdate()
        # echom this.separator_valid
        for [l, r] in this.sections
            this.separator_content[l] = this.GetSepratorContent(config, active, 1, l)
            this.separator_content[r] = this.GetSepratorContent(config, active, 0, r)
        endfor
        this.status_line = [['a', 'b', 'c'], ['x', 'y', 'z']]
            -> map((i, half): string => half
                # -> map((_, sec): string => this.section_content[sec])
                -> map((_, sec): string => i == 0
                    ? this.MergeSectionSeparatorContent(1, sec)
                    : this.MergeSectionSeparatorContent(0, sec))
                    # ? [this.section_content[sec], this.separator_content[sec]] -> join('')
                    # : [this.separator_content[sec], this.section_content[sec]] -> join(''))
                    # ? this.GetSectionContent(config, active, 1, sec)
                    # : this.GetSectionContent(config, active, 0, sec))
                -> join(''))
            -> join('%#Oneline_Middle#%=')

        # echom this.status_line
        return this.status_line
    enddef
endclass

export final Statusline = StatusLine.new()
