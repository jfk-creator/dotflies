-- === BOOTSTRAP LAZY.NVIM ===
-- This code block checks if lazy.nvim is installed and installs it if not.
-- It MUST be at the very top of your init.lua.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
-- === END BOOTSTRAP LAWZY.NVIM ===

-- escape terminal mode with ESC:
vim.keymap.set('t', '<Esc>', "<C-\\><C-n><C-w>h",{silent = true})
-- Lua
-- 1. Create a global variable to track the state
vim.g.cmp_enabled = true

-- 2. Define the toggle function
local function toggle_cmp()
    vim.g.cmp_enabled = not vim.g.cmp_enabled -- Toggle the state

    -- Re-configure nvim-cmp with the new enabled state
    require('cmp').setup({
        enabled = vim.g.cmp_enabled
    })

    -- Display a notification
    vim.notify(
        "nvim-cmp: " .. (vim.g.cmp_enabled and "ENABLED" or "DISABLED"),
        vim.log.levels.INFO
    )
end

-- Open Preview on Leader-p
vim.api.nvim_create_autocmd("FileType", {
    pattern = "typst",
    callback = function()
        -- Assuming your maplocalleader is set (default is usually backslash \)
        -- Press \p to open preview
        vim.keymap.set('n', '<leader>p', ':TypstPreview<CR>', { 
            buffer = true, 
            desc = "Open Typst Preview" 
        })
    end,
})

-- Toggle Completion

vim.keymap.set('i', '<C-t>', toggle_cmp, { desc = 'Toggle Auto Completion (nvim-cmp)' })
vim.keymap.set('n', '<C-t>', toggle_cmp, { desc = 'Toggle Auto Completion (nvim-cmp)' })


-- vim settings:
vim.o.compatible = false
vim.cmd('syntax on')
vim.o.number = true
vim.o.relativenumber = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.clipboard = 'unnamedplus'
vim.o.laststatus = 2
vim.g.mapleader = ' ' -- Sets the leader key to spacebar

-- errors at end of line
vim.diagnostic.config({
    signs = false,
})
-- Plugin management with lazy.nvim
require('lazy').setup({
    -- zenbones (current colorscheme)
    {
        --        "zenbones-theme/zenbones.nvim",
        --        dependencies = "rktjmp/lush.nvim",
        --        lazy = false,
        --        priority = 1000,
        --        config = function()
        --            vim.cmd.colorscheme('zenbones')
        --        end,
    },
    -- tokyonight (fallback colorscheme) - still there if you need it, but zenbones is priority
    {
        'folke/tokyonight.nvim',
        config = function()
            require('tokyonight').setup({})
        end,
    },
    {
        "brenton-leighton/multiple-cursors.nvim",
        version = "*",  -- Use the latest tagged version
        opts = {},  -- This causes the plugin setup function to be called
        keys = {
            --{"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}, desc = "Add cursor and move down"},
            --{"<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "x"}, desc = "Add cursor and move up"},

            --{"<A-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "i", "x"}, desc = "Add cursor and move up"},
            --{"<A-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "i", "x"}, desc = "Add cursor and move down"},

            {"<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = {"n", "i"}, desc = "Add or remove cursor"},

            {"<C-i>", "<Cmd>MultipleCursorsAddVisualArea<CR>", mode = {"x"}, desc = "Add cursors to the lines of the visual area"},

            {"<C-a>", "<Cmd>MultipleCursorsAddMatches<CR>", mode = {"n", "x"}, desc = "Add cursors to cword"},
            {"<Leader>A", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = {"n", "x"}, desc = "Add cursors to cword in previous area"},

            {"<C-d>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = {"n", "x"}, desc = "Add cursor and jump to next cword"},
            {"<C-e>", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = {"n", "x", "i"}, desc = "Jump to next cword"},

            {"<Leader>l", "<Cmd>MultipleCursorsLock<CR>", mode = {"n", "x"}, desc = "Lock virtual cursors"},
        },
    },
    {
        'chomosuke/typst-preview.nvim',
        ft = 'typst',
        version = '1.*',
        build = function() require 'typst-preview'.update() end,
    },

    -- LSP config
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and other tools
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            -- This sets up nvim-lspconfig to automatically use mason-installed servers
            require("mason").setup()
            require("mason-lspconfig").setup({
                -- List of servers to install automatically
                ensure_installed = { "ts_ls", "clangd" },
            })
            require'lspconfig'.tinymist.setup{
                settings = {
                    -- exportPdf = "onType", -- Optional: Export PDF as you type
                    -- outputPath = "$root/target/$dir/$name", -- Optional: Output location
                    formatterMode = "typstyle", -- Optional: Set formatter to 'typstyle'
                }
            }

            -- Attach nvim-lspconfig to clangd
            require("lspconfig").clangd.setup({})
            -- Attach nvim-lspconfig to tsserver
            require("lspconfig").ts_ls.setup({
                -- You can add custom settings here if needed
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact"
                }
            })

            -- Optional: create a keymap for convenient LSP commands
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover information" })
        end
    },
    -- CMP config:
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'onsails/lspkind.nvim', -- Add this to get the kind icons
        },
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    -- `<C-b>` and `<C-f>` are standard to scroll through the menu
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    -- Use `<C-Space>` to manually trigger the completion menu
                    ['<C-Space>'] = cmp.mapping.complete(),
                    -- Use `<C-e>` to close the menu and cancel completion
                    ['<C-e>'] = cmp.mapping.abort(),
                    -- The crucial part: map up and down arrows to navigate the menu
                    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    -- You can also use `<C-n>` and `<C-p>`
                    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    -- `<CR>` (Enter) to confirm and insert the selected item
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                },
                formatting = {
                    format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }),
                },
                -- other settings
            })
        end
    },
    {
        'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    -- Treesitter is a modern syntax highlighter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Add all the languages you want to highlight
                ensure_installed = {
                    "javascript",
                    "typescript",
                    "tsx",
                },
                -- Enable highlighting
                highlight = {
                    enable = true,
                },
                -- Enable indentation
                indent = {
                    enable = true,
                }
            })
        end,
    },
  -- 1. Add this BEFORE image.nvim to handle Lua dependencies
    {
        "vhyrro/luarocks.nvim",
        priority = 1001, -- this plugin needs to run before anything else
        opts = {
            rocks = { "magick" }, -- This automatically installs the magick Lua rock
        },
    },

    -- 2. Updated Image viewer config
    {
        "3rd/image.nvim",
        dependencies = { "luarocks.nvim" }, 
        config = function()
            require("image").setup({
                -- backend = "kitty",  <-- COMMENTED OUT. Let it auto-detect!
                -- Only use "kitty" if you are actually using the Kitty Terminal.
                -- If you use WezTerm, iTerm2, or Ghostty, let this be nil.
                backend = nil, 
                
                integrations = {
                    markdown = {
                        enabled = true,
                        clear_in_insert_mode = false,
                        download_remote_images = true,
                        only_render_image_at_cursor = false,
                        filetypes = { "markdown", "vimwiki", "html" },
                    },
                    neorg = {
                        enabled = true,
                        clear_in_insert_mode = false,
                        download_remote_images = true,
                        only_render_image_at_cursor = false,
                        filetypes = { "norg" },
                    },
                    typst = {
                        enabled = true,
                        filetypes = { "typst" },
                    },
                },
                max_width = nil,
                max_height = nil,
                max_width_window_percentage = nil,
                max_height_window_percentage = 50,
                window_overlap_clear_enabled = false, 
                editor_only_render_when_focused = false, 
                tmux_show_only_in_active_window = false, 
                hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.svg" }, 
            })
        end
    },
})
-- telescope

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-f>g', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<C-f>b', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<C-f>h', builtin.help_tags, { desc = 'Telescope help tags' })

local telescope = require("telescope")
local previewers = require("telescope.previewers")

-- 1. DEFINE THIS FIRST (Required for the 'else' block to work)
local previewers = require('telescope.previewers')

local new_maker = function(filepath, bufnr, opts)
    filepath = vim.fn.expand(filepath)

    local image_extensions = { "png", "jpg", "jpeg", "gif", "webp" }
    local split_path = vim.split(filepath:lower(), ".", { plain = true })
    local extension = split_path[#split_path]

    if vim.tbl_contains(image_extensions, extension) then
        vim.api.nvim_set_option_value("filetype", "markdown", { buf = bufnr })
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "![image](" .. filepath .. ")" })
    else
        -- If not an image, use the default previewer
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
end -- FIX: "end" must be lowercase

require('telescope').setup {
    defaults = {
        buffer_previewer_maker = new_maker,
        preview = {
            filesize_limit = 0.1, -- limits previews to files smaller than 0.1MB (100KB)
        },
    }
}
