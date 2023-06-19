vim9script

def Mode_Content(): string
    const mode_map: dict<string> = g:oneline.mode_map
    var mode_char: string = mode(1)
    mode_char = has_key(mode_map, mode_char) 
        ? mode_char 
        : has_key(mode_map, mode_char[0])
        ? mode_char[0]
        : mode_char[0] ==# 'c'
        ? getcmdtype()
        : ''
    return mode_map[mode_char]
enddef

export final preset: dict<any> = {
    active: {
        oneline_a: ['mode', 'paste'],
        oneline_b: [],
        oneline_c: ['filename', 'readonly'],
        oneline_x: ['encoding', 'fileformat', 'filetype'],
        oneline_y: ['percent'],
        oneline_z: ['lineinfo']
    },
    inactive: {
        oneline_a: [],
        oneline_b: ['filename'],
        oneline_c: ['readonly'],
        oneline_x: ['percent'],
        oneline_y: [],
        oneline_z: ['time']
    },
    component: {
        mode: {
            content: Mode_Content,
            hlgroup: ''
        },
        paste: {
            content: () => &paste ? 'PASTE' : '',
            hlgroup: ''
        },
        filename: {
            content: '%t%( %m%)',
            hlgroup: ''
        },
        readonly: {
            content: () => &readonly ? '' : '',
            hlgroup: ''
        },
        modified: {
            content: () => &modified || !&modifiable ? '%m' : '',
            hlgroup: ''
        },
        encoding: {
            content: &encoding,
            hlgroup: ''
        },
        fileformat: {
            content: &fileformat,
            hlgroup: ''
        },
        filetype: {
            content: '%y',
            hlgroup: ''
        },
        percent: {
            content: '%p%%',
            hlgroup: ''
        },
        lineinfo: {
            content: '%l:%v',
            hlgroup: ''
        }
    },
    theme: 'default',
    separator: { left: '', right: '', margin: ' '},
    subseparator: { left: '', right: '', margin: ' '},
    mode_map: {
        n: 'NORMAL',   
        niI: 'I-NORMAL',
        niR: 'R-NORMAL',
        niV: 'R-NORMAL',
        v: 'VISUAL',
        V: 'V-LINE',
        ["\<C-V>"]: 'V-BLOCK',
        s: 'SELECT',
        S: 'S-LINE',
        ["\<C-S>"]: 'S-BLOCK',
        i: 'INSERT',
        R: 'REPLACE',
        Rv: 'V-REPLACE',
        t: 'TERMINAL',
        [':']: 'COMMAND',
        ['>']: 'DEBUG',
        ['/']: 'SEARCH',
        ['?']: 'SEARCH',
        ['@']: 'PROMPT',
        ['-']: 'EX-INSERT',
        ['=']: 'EXPR',
    }
}
