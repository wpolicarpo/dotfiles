-- ============================================================
-- init.lua
-- ============================================================
-- Structure:
--   1. General
--   2. UI & Appearance
--   3. Indentation & Whitespace
--   4. Search
--   5. Splits & Navigation
--   6. Editing & Convenience
--   7. Key Mappings
--   8. Filetype Overrides
--   9. Environment-specific config (local overrides)
-- ============================================================


-- ------------------------------------------------------------
-- 1. General
-- ------------------------------------------------------------
vim.opt.encoding    = "utf-8"
vim.opt.history     = 500
vim.opt.autoread    = true
vim.opt.hidden      = true
vim.opt.backup      = false
vim.opt.swapfile    = false
vim.opt.undofile    = true
vim.opt.undodir     = vim.fn.expand("~/.local/share/nvim/undo")

-- Create undo dir if it doesn't exist
vim.fn.mkdir(vim.fn.expand("~/.local/share/nvim/undo"), "p")


-- ------------------------------------------------------------
-- 2. UI & Appearance
-- ------------------------------------------------------------
vim.opt.number         = true
vim.opt.relativenumber = false
vim.opt.cursorline     = true
vim.opt.signcolumn     = "yes"
vim.opt.scrolloff      = 8
vim.opt.sidescrolloff  = 8
vim.opt.laststatus     = 2
vim.opt.showcmd        = true
vim.opt.showmatch      = true
vim.opt.wildmenu       = true
vim.opt.wildmode       = "list:longest"
vim.opt.ruler          = true
vim.opt.errorbells     = false
vim.opt.visualbell     = true
vim.opt.termguicolors  = true
vim.opt.colorcolumn    = "72,120"

-- ------------------------------------------------------------
-- 3. Indentation & Whitespace
-- ------------------------------------------------------------
vim.opt.expandtab   = true
vim.opt.tabstop     = 2
vim.opt.shiftwidth  = 2
vim.opt.softtabstop = 2
vim.opt.autoindent  = true
vim.opt.smartindent = true
vim.opt.list        = true
vim.opt.listchars   = { tab = "→ ", trail = "·", extends = ">", precedes = "<", nbsp = "+" }


-- ------------------------------------------------------------
-- 4. Search
-- ------------------------------------------------------------
vim.opt.incsearch   = true
vim.opt.hlsearch    = true
vim.opt.ignorecase  = true
vim.opt.smartcase   = true
vim.opt.gdefault    = true


-- ------------------------------------------------------------
-- 5. Splits & Navigation
-- ------------------------------------------------------------
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")


-- ------------------------------------------------------------
-- 6. Editing & Convenience
-- ------------------------------------------------------------
vim.opt.backspace    = { "indent", "eol", "start" }
vim.opt.clipboard    = "unnamedplus"   -- system clipboard (Linux/macOS with provider)
vim.opt.mouse        = "a"
vim.opt.formatoptions:remove({ "c", "r", "o" })  -- no auto comment leaders
vim.opt.joinspaces   = false


-- ------------------------------------------------------------
-- 7. Key Mappings
-- ------------------------------------------------------------
vim.g.mapleader = " "

local map = vim.keymap.set

-- Clear search highlight
map("n", "<leader>/", ":nohlsearch<CR>")

-- Save / quit
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>x", ":x<CR>")

-- Buffer navigation
map("n", "<leader>bn", ":bnext<CR>")
map("n", "<leader>bp", ":bprevious<CR>")
map("n", "<leader>bd", ":bdelete<CR>")

-- File explorer (netrw)
map("n", "<leader>e", ":Explore<CR>")

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centred when jumping
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Paste without overwriting register
map("x", "<leader>p", '"_dP')

-- Yank to end of line
map("n", "Y", "y$")


-- ------------------------------------------------------------
-- 8. Filetype Overrides
-- ------------------------------------------------------------
vim.api.nvim_create_augroup("filetype_overrides", { clear = true })

-- Python: 4-space indent
vim.api.nvim_create_autocmd("FileType", {
  group   = "filetype_overrides",
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab   = true
    vim.opt_local.tabstop     = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Markdown: wrap + spell check
vim.api.nvim_create_autocmd("FileType", {
  group   = "filetype_overrides",
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap      = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell     = true
    vim.opt_local.spelllang = "en_us"
  end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group   = "filetype_overrides",
  pattern = { "*.rb", "*.js", "*.ts", "*.go", "*.py", "*.rs" },
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})


-- ------------------------------------------------------------
-- 9. Environment-specific config (local overrides)
-- ------------------------------------------------------------
-- Place machine-specific settings in ~/.config/nvim/local.lua
-- This file is intentionally not tracked in version control.
--
-- Examples of what to put there:
--   - colorscheme
--   - plugin manager (lazy.nvim) + plugin list
--   - LSP setup (nvim-lspconfig)
--   - work-specific paths or env vars
--
-- To split by environment, put one of these in local.lua:
--   require("work")      -- loads ~/.config/nvim/lua/work.lua
--   require("personal")  -- loads ~/.config/nvim/lua/personal.lua

local local_config = vim.fn.expand("~/.config/nvim/local.lua")
if vim.fn.filereadable(local_config) == 1 then
  dofile(local_config)
end