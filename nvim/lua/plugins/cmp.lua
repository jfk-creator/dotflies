-- This file configures nvim-cmp for buffer and path autocompletion.
-- It's enabled by default.

return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-buffer', -- Source for words in the current buffer
        'hrsh7th/cmp-path',   -- Source for file system paths
    },
    config = function()
        local cmp = require('cmp')

        cmp.setup({
            -- Basic mappings for completion menu navigation and confirmation
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll documentation up
                ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Scroll documentation down
                ['<C-Space>'] = cmp.mapping.complete(),  -- Manually trigger completion
                ['<C-e>'] = cmp.mapping.abort(),         -- Abort completion menu
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
                -- Use Tab/S-Tab to navigate the completion menu
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback() -- Fallback to default Tab behavior if no menu
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback() -- Fallback to default Shift-Tab behavior
                    end
                end, { 'i', 's' }),
            }),

            -- Sources for completion: buffer words and file paths
            sources = cmp.config.sources({
                { name = 'buffer' },
                { name = 'path' },
            }),

            -- Visuals for the completion window
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            -- Optional: Autotrigger completion after typing 1 character
            -- If you prefer manual trigger with <C-Space>, you can remove this.
            completion = {
                completeopt = 'menu,menuone,noinsert', -- Display options
            },
            -- This makes completion pop up as you type
            enabled = function()
                -- You can add logic here to only enable for certain filetypes if desired
                return true
            end,
            -- Optionally, automatically show completion after typing:
            -- documentation = {
            --      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            -- },
        })
    end,
}
