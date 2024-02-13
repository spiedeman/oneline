vim9script

import './solarized_dark.vim' as dark 
import './solarized_light.vim' as light

export const theme: dict<any> = {
    'dark': dark.theme,
    'light': light.theme
}
