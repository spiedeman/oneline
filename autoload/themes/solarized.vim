vim9script

const Pallete: dict<string> = {
    base03: '#002b36',
    base02: '#073642',
    base01: '#586e75',
    base00: '#657b83',
    base0: '#839496',
    base1: '#93a1a1',
    base2: '#eee8d5',
    base3: '#fdf6e3',
    yellow: '#b58900',
    orange: '#cb4b16',
    red: '#dc322f',
    magenta: '#d33682',
    violet: '#6c71c4',
    blue: '#268bd2',
    cyan: '#2aa198',
    green: '#859900'
}

export const theme: dict<any> = {
    'normal': {
        'a': {'guifg': Pallete.base03, 'guibg': Pallete.blue, cterm: {'bold': 1}},
        'b': {'guifg': Pallete.base03, 'guibg': Pallete.base1},
        'c': {'guifg': Pallete.base1, 'guibg': Pallete.base02}
    },
    'insert': {'guifg': Pallete.base03, 'guibg': Pallete.green, cterm: {'bold': 1}},
    'visual': {'guifg': Pallete.base03, 'guibg': Pallete.magenta, cterm: {'bold': 1}},
    'replace': {'guifg': Pallete.base03, 'guibg': Pallete.red, cterm: {'bold': 1}},
    'inactive': {
        'a': {'guifg': Pallete.base0, 'guibg': Pallete.base02, cterm: {'bold': 1}},
        'b': {'guifg': Pallete.base03, 'guibg': Pallete.base00},
        'c': {'guifg': Pallete.base01, 'guibg': Pallete.base02}
    }
}
