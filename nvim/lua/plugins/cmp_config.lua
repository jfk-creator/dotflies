local cmp = require('cmp')
local cmp_sources = require('cmp.sources')
local lspkind = require('lspkind')

cmp.setup({
  sources = {
    -- This tells cmp to use the LSP for completion
    { name = 'nvim_lsp' },
    -- Other sources, like snippets or buffer words
    { name = 'buffer' },
  },
  formatting = {
    format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }),
  },
  -- other cmp settings
})
