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

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.diagnostic.config { virtual_text = true }

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

vim.pack.add { { src = gh 'nvim-lua/plenary.nvim' } }

vim.pack.add { { src = gh 'folke/todo-comments.nvim' } }
local todo_comments = require 'todo-comments'
todo_comments.setup {}

vim.pack.add { { src = gh 'stevearc/conform.nvim' } }
local conform = require 'conform'
conform.setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    nix = { 'alejandra' },
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
end, { desc = 'Format Buffer' })

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

vim.pack.add { { src = gh 'lewis6991/gitsigns.nvim' } }
local gitsigns = require 'gitsigns'
gitsigns.setup()

vim.keymap.set('n', '[c', function()
  gitsigns.nav_hunk 'prev'
end, { desc = 'Prevous Hunk' })

vim.keymap.set('n', ']c', function()
  gitsigns.nav_hunk 'next'
end, { desc = 'Next Hunk' })

vim.keymap.set('n', '<leader>hr', function()
  if vim.wo.diff then
    vim.cmd.normal { ']c', bang = true }
  else
    gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end
end, { desc = 'Reset Hunk' })

vim.keymap.set('n', '<leader>hs', function()
  if vim.wo.diff then
    vim.cmd.normal { ']c', bang = true }
  else
    gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end
end, { desc = 'Stage Hunk' })

vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage Buffer' })
vim.keymap.set('n', '<leader>hb', function()
  gitsigns.blame_line { full = true }
end, { desc = 'Blame Line' })

vim.pack.add { { src = gh 'ibhagwan/fzf-lua' } }
local fzf_lua = require 'fzf-lua'
fzf_lua.setup {
  lsp = {
    jump1 = true,
  },
}

vim.keymap.set('n', '<leader><leader>', fzf_lua.files, { desc = 'Files' })
vim.keymap.set('n', '<leader>,', fzf_lua.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', fzf_lua.blines, { desc = 'Search Buffer' })
vim.keymap.set('n', '<leader>r', fzf_lua.resume, { desc = 'Resume fzf' })
vim.keymap.set('n', '<leader>q', fzf_lua.quickfix, { desc = 'Quickfix List' })
vim.keymap.set('n', '<leader>l', fzf_lua.loclist, { desc = 'Location List' })
vim.keymap.set('n', '<leader>u', fzf_lua.undotree, { desc = 'Undotree' })

vim.keymap.set('n', '<leader>fb', fzf_lua.buffers, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>ff', fzf_lua.files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', fzf_lua.git_files, { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>fr', fzf_lua.oldfiles, { desc = 'Find Recent' })

vim.keymap.set('n', '<leader>sb', fzf_lua.blines, { desc = 'Search Buffer' })
vim.keymap.set('n', '<leader>sB', fzf_lua.lines, { desc = 'Search Open Buffers' })
vim.keymap.set('n', '<leader>sg', fzf_lua.live_grep, { desc = 'Search Grep' })
vim.keymap.set('n', '<leader>sw', fzf_lua.grep_cword, { desc = 'Search Word' })
vim.keymap.set('n', '<leader>sW', fzf_lua.grep_cword, { desc = 'Search WORD' })
vim.keymap.set('n', '<leader>sj', fzf_lua.jumps, { desc = 'Search Jumps' })
vim.keymap.set('n', '<leader>sm', fzf_lua.marks, { desc = 'Search Marks' })
vim.keymap.set('n', '<leader>sq', fzf_lua.grep_quickfix, { desc = 'Search Quickfix' })
vim.keymap.set('n', '<leader>sl', fzf_lua.grep_loclist, { desc = 'Search Location' })

vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter' } }
require('nvim-treesitter').setup()

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    local available_langs = require('nvim-treesitter').get_available()
    local is_available = vim.tbl_contains(available_langs, lang)
    if is_available then
      local installed_langs = require('nvim-treesitter').get_installed()
      local installed = vim.tbl_contains(installed_langs, lang)
      if not installed then
        require('nvim-treesitter').install(lang):wait()
      end
      vim.treesitter.start()
      require('nvim-treesitter').indentexpr()
    end
  end,
})

vim.pack.add { { src = gh 'neovim/nvim-lspconfig' } }
autocmd('LspAttach', {
  group = augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    nmap('grn', vim.lsp.buf.rename, 'Rename')
    nmap('gra', fzf_lua.lsp_code_actions, 'Code Action')
    nmap('gd', fzf_lua.lsp_definitions, 'Go to Definition')
    nmap('gD', fzf_lua.lsp_declarations, 'Go to Declaration')
    nmap('grr', fzf_lua.lsp_references, 'References')
    nmap('gri', fzf_lua.lsp_implementations, 'Implementation')
    nmap('grt', fzf_lua.lsp_typedefs, 'Type Definition')

    nmap('<leader>ds', vim.lsp.buf.document_symbol, 'Document Symbols')
    nmap('<leader>ws', vim.lsp.buf.workspace_symbol, 'Workspace Symbols')

    nmap('<leader>dq', function()
      vim.diagnostic.setqflist { open = false }
    end, 'Diagnostics to Quickfix')
    nmap('<leader>dl', function()
      vim.diagnostic.setloclist { open = false }
    end, 'Diagnostics to Loclist')

    nmap('[q', vim.cmd.cprev, 'Prev Quickfix')
    nmap(']q', vim.cmd.cnext, 'Next Quickfix')

    nmap('[d', function()
      vim.diagnostic.jump { count = -1, float = true }
    end, 'Prev Diagnostic')
    nmap(']d', function()
      vim.diagnostic.jump { count = 1, float = true }
    end, 'Next Diagnostic')
  end,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'Lua 5.4' },
      completion = { enable = true },
      diagnostics = { enable = true, globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
    },
  },
})

vim.lsp.enable {
  'lua_ls',
  'nixd',
}

vim.pack.add { { src = gh 'mrcjkb/rustaceanvim' } }

vim.pack.add { { src = gh 'saecki/crates.nvim' } }
require('crates').setup {
  lsp = {
    enabled = true,
    actions = true,
    completion = true,
    hover = true,
  },
}
