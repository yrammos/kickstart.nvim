return {
    'f3fora/nvim-texlabconfig',
    config = function()
        require('texlabconfig').setup({
            cache_root = '/Users/rammos/.cache/nvim'
        })
    end,
    ft = { 'tex', 'bib' }, -- Lazy-load on filetype
    build = 'go build -o ~/.config/nvim-texlabconfig/'
}
