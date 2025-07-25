-- This file contains the LSP and nvim-cmp configuration

return {
    -- LSP Configuration
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Ensure nvim-cmp and LuaSnip are loaded BEFORE lspconfig for proper integration
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
        },
        config = function()
            local lspconfig = require('lspconfig')
            local cmp = require('cmp') -- Ensure cmp is loaded if using it in LspAttach
            local luasnip = require('luasnip') -- Ensure luasnip is loaded if using it in LspAttach

            -- Setup clangd
            lspconfig.clangd.setup({
                filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
                root_dir = lspconfig.util.root_pattern('.git', 'compile_commands.json', 'Makefile'),
                -- You can add more specific settings here if needed, e.g., for compile_commands.json
                -- capabilities = capabilities, -- If you define global capabilities for all LSPs
            })

            -- Global mappings for LSP
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)

                    -- Keymaps for nvim-cmp specific actions within LSPAttach context (optional)
                    -- if cmp and luasnip then
                    --     vim.keymap.set("i", "<C-y>", function() cmp.close() end, opts) -- You might not need this here if mapped globally
                    --     vim.keymap.set("i", "<C-Space>", cmp.mapping.complete(), opts)
                    --     vim.keymap.set("i", "<C-l>", luasnip.jump, opts)
                    --     vim.keymap.set("i", "<C-h>", luasnip.jump_back, opts)
                    -- end
                end,
            })
        end
    },

    -- Autocompletion (nvim-cmp)
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',       -- LSP source for nvim-cmp
            'hrsh7th/cmp-buffer',         -- Buffer words source
            'hrsh7th/cmp-path',           -- File system paths source
            'saadparwaiz1/cmp_luasnip',   -- Snippets source
            'L3MON4D3/LuaSnip',           -- Snippet engine
            'rafamadriz/friendly-snippets', -- Friendly snippets
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            require('luasnip.loaders.from_vscode').lazy_load() -- Load friendly snippets

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For snippets
                    { name = 'buffer' },
                    { name = 'path' },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })
        end,
    },
}
