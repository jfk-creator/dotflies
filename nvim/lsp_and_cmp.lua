-- This file contains the nvim-cmp (autocompletion) configuration for buffer words

return {
    -- Autocompletion (nvim-cmp)
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- We only need cmp-buffer for autocompletion within the document
            'hrsh7th/cmp-buffer',         -- Buffer words source
            'hrsh7th/cmp-path',           -- File system paths source (useful to keep)
            -- No LSP or snippet dependencies needed if only buffer completion
            -- 'saadparwaiz1/cmp_luasnip',
            -- 'L3MON4D3/LuaSnip',
            -- 'rafamadriz/friendly-snippets',
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                -- No snippet expansion needed if no snippets
                -- snippet = {
                --     expand = function(args)
                --         -- luasnip.lsp_expand(args.body)
                --     end,
                -- },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(), -- Manually trigger completion
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    -- Only use Tab/S-Tab for completion menu navigation if no snippets
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                -- Initially, only use buffer and path sources, and disable auto-popup
                sources = cmp.config.sources({
                    { name = 'buffer' },
                    { name = 'path' },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                enabled = false, -- CMP is OFF by default
            })

            -- =======================================================
            -- Autocompletion Toggle Function and Keybinding
            -- =======================================================

            local function toggle_cmp_for_buffer()
                local bufnr = vim.api.nvim_get_current_buf()

                if cmp.is_enabled(bufnr) then
                    -- If cmp is currently enabled for this buffer, disable it
                    cmp.setup.buffer({ bufnr = bufnr, enabled = false })
                    vim.notify("Autocompletion (nvim-cmp) OFF for buffer " .. bufnr, vim.log.levels.INFO)
                else
                    -- If cmp is currently disabled, enable it with buffer/path sources
                    cmp.setup.buffer({
                        bufnr = bufnr,
                        enabled = true,
                        sources = cmp.config.sources({
                            { name = 'buffer' },
                            { name = 'path' },
                        }),
                    })
                    vim.notify("Autocompletion (nvim-cmp) ON for buffer " .. bufnr, vim.log.levels.INFO)
                end
            end

            -- Map the toggle function to your desired keybinding
            -- Using <leader>ta (Toggle Autocompletion) as an example
            vim.keymap.set('n', '<leader>ta', toggle_cmp_for_buffer, { desc = "Toggle Autocompletion (Buffer/Path)" })

            -- =======================================================
            -- End Autocompletion Toggle Section
            -- =======================================================
        end,
    },
}
