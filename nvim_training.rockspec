local _MODREV, _SPECREV = 'scm', '-1'
rockspec_format = "3.0"
package = 'nvim_training'
version = _MODREV .. _SPECREV

description = {
   summary = 'Train nvim easily and repeatedly',
   labels = { "neovim" },
   detailed = [[
    ""
   ]],
   homepage = 'https://github.com/Weyaaron/nvim-training',
   license = 'MIT',
}

dependencies = {
   'lua >= 5.1, < 5.4',
   'cjson'
}

source = {
   url = 'https://github.com/Weyaaron/nvim-training',
}

build = {
   type = 'builtin',
   copy_directories = {
     'media',
     'plugin'
   }
}