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
-- === END BOOTSTRAP LAZY.NVIM ===
-- leader key to spacebar
vim.g.mapleader = ' '

-- escape terminal mode with ESC:
vim.keymap.set('t', '<Esc>', "<C-\\><C-n><C-w>h",{silent = true})

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
            
                {"<Leader>m", "<Cmd>MultipleCursorsAddVisualArea<CR>", mode = {"x"}, desc = "Add cursors to the lines of the visual area"},
            
                {"<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = {"n", "x"}, desc = "Add cursors to cword"},
                {"<Leader>A", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = {"n", "x"}, desc = "Add cursors to cword in previous area"},
            
                {"<Leader>d", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = {"n", "x"}, desc = "Add cursor and jump to next cword"},
                {"<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = {"n", "x"}, desc = "Jump to next cword"},
            
            {"<Leader>l", "<Cmd>MultipleCursorsLock<CR>", mode = {"n", "x"}, desc = "Lock virtual cursors"},
        },
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
        -- Add more keymaps as you learn them
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

})
