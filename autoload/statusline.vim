vim9script

import autoload './colorscheme.vim' as Color

def GetSectionHighlightName(section: string): string
    return ''
enddef

def GetComponentContent(component: dict<any>, name: string): string
    var content_type: any = type(component.content)
    return content_type == v:t_string
        ? component.content
        : content_type == v:t_func
        ? component.content()
        : ' '
enddef

def GetSectionContent(self: dict<any>, is_active: bool, is_left: bool, section: string): string
    var active_type: string = is_active ? 'active' : 'inactive'
    var sec_name: string = 'oneline_' .. section
    var submargin: string = self.subseparator.margin
    var subseparator: string = is_left ? self.subseparator.left : self.subseparator.right
    var result: string = deepcopy(self[active_type][sec_name])
        -> map((_, subitem): string => self.component->has_key(subitem)
            ? GetComponentContent(self.component[subitem], subitem)
            : '')
        -> filter((_, subitem): bool => !!subitem)
        -> map((_, subitem): string => subitem)
        -> join(submargin .. subseparator .. submargin)
    return result
enddef

g:oneline_config.GetSectionContent_active_left = function(GetSectionContent, [g:oneline_config, v:true, v:true])
g:oneline_config.GetSectionContent_active_right = function(GetSectionContent, [g:oneline_config, v:true, v:false])
g:oneline_config.GetSectionContent_inactive_left = function(GetSectionContent, [g:oneline_config, v:false, v:true])
g:oneline_config.GetSectionContent_inactive_right = function(GetSectionContent, [g:oneline_config, v:false, v:false])

export def Statusline(self: dict<any>, active: bool): string
    var func_name: string = join([
        'g:oneline_config.GetSectionContent',
        active ? 'active' : 'inactive'
    ], '_')
    var result: string = [['a', 'b', 'c'], ['x', 'y', 'z']]
        -> map((i, half): string => half
            -> map((_, sec): string => i == 0
                ? join([
                '%(', 
                '%{%' .. func_name .. '_left("' .. sec .. '")%}',
                self.separator.left .. '%)'
                ], self.separator.margin)
                : join([
                '%(' .. self.separator.right,
                '%{%' .. func_name .. '_right("' .. sec .. '")%}',
                '%)'
                ], self.separator.margin))
            -> join(''))
        -> join('%=')
    # echom result
    return result
enddef

# export def OldStatusline(config: dict<any>, active: bool): string
#     var sections = deepcopy(active ? config.active : config.inactive)
#     var margin = config.separator.margin
#     var submargin = config.subseparator.margin

#     var result: string = [['a', 'b', 'c'], ['x', 'y', 'z']]
#         -> map((i, half): string => half
#             -> map((_, sec): string => sections[join(['oneline', sec], '_')]
#                 -> map((_, subitem): string => config.component->has_key(subitem) 
#                     ? GetComponentContent(config.component[subitem], subitem)
#                     : '')
#                 -> filter((_, subitem): bool => len(subitem) > 0)
#                 -> map((_, subitem): string => submargin .. subitem .. submargin)
#                 -> join(i == 0 ? config.subseparator.left : config.subseparator.right))
#             -> filter((_, sec): bool => !!sec)
#             -> map((_, sec): string => margin .. sec .. margin)
#             # -> map((_, sec): string => GetSectionHighlightName(sec) .. margin .. sec .. margin)
#             -> join(i == 0 ? config.separator.left : config.separator.right))
#         -> join('%=')

#     # echom result
#     return result
# enddef
