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

-- Plugin management with lazy.nvim
require('lazy').setup({
    -- zenbones (current colorscheme)
    {
        "zenbones-theme/zenbones.nvim",
        dependencies = "rktjmp/lush.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('zenbones')
        end,
    },
    -- tokyonight (fallback colorscheme) - still there if you need it, but zenbones is priority
    {
        'folke/tokyonight.nvim',
        -- config = function()
        --   require('tokyonight').setup({})
        -- end,
    },

    -- Load your LSP and nvim-cmp configuration from the separate file
    require('plugins.cmp'),
})
