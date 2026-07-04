vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.termguicolors = true
vim.opt.background = 'light'

vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lprev<CR>zz')
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local gh = function(x)
  return 'https://github.com/' .. x
end

vim.pack.add { { src = gh 'nlknguyen/papercolor-theme' } }
vim.cmd.colorscheme 'PaperColor'

vim.pack.add { { src = gh 'folke/which-key.nvim' } }
vim.keymap.set('n', '<leader>?', function()
  require('which-key').show { global = false }
end, { desc = 'Buffer Local Keymaps (which-key)' })

vim.pack.add { { src = gh 'stevearc/oil.nvim' } }
require('oil').setup {}
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

vim.pack.add { { src = gh 'mason-org/mason.nvim' } }
require('mason').setup {}

vim.pack.add { { src = gh 'stevearc/conform.nvim' } }
local conform = require 'conform'
conform.setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    c = { 'clang-format' },
  },
  default_format_opts = { lsp_format = 'fallback' },
  format_on_save = function(bufnr)
    local disabled_filetypes = {
      c = true,
      cpp = true,
    }
    if disabled_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return { timeout_ms = 500 }
    end
  end,
}
vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
  conform.format { lsp_fallback = true, async = false, timeout_ms = 1000 }
end, { desc = '[F]ormat Buffer' })

vim.pack.add { { src = gh 'numToStr/FTerm.nvim' } }
local fterm = require 'FTerm'

vim.keymap.set('n', '<C-\\>', function()
  fterm:toggle()
end, { desc = 'Toggle Terminal' })

vim.keymap.set('t', '<C-\\>', function()
  fterm:toggle()
end, { desc = 'Toggle Terminal' })

vim.pack.add { { src = gh 'saghen/blink.lib' }, { src = gh 'saghen/blink.cmp' } }
local cmp = require 'blink.cmp'
cmp.build():pwait()
cmp.setup {
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
  keymap = {
    preset = 'default',
    ['<C-l>'] = { 'snippet_forward', 'fallback' },
    ['<C-h>'] = { 'snippet_backward', 'fallback' },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}

vim.pack.add { { src = gh 'ibhagwan/fzf-lua' } }
require('fzf-lua').setup {}

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  settings = {
    Lua = {
      runtime = { version = 'Lua 5.4' },
      completion = { enable = true },
      diagnostics = { enable = true, globals = { 'vim' } },
      workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
    },
  },
})

vim.lsp.enable {
  'lua_ls',
}
vim.diagnostic.config { virtual_text = true }
