vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
    },

    { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("options")
require("nvchad.autocmds")

vim.schedule(function()
    require("mappings")
end)

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.cmd([[autocmd FileType javascriptreact,typescriptreact,html setlocal commentstring={/*\ %s\ */}]])

--
-- -- Menonaktifkan Noice sementara saat menyimpan file
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   callback = function()
--     -- Menonaktifkan Noice
--     require("noice").disable()
--
--     -- Mengaktifkan kembali Noice setelah delay (1 detik)
--     vim.defer_fn(function()
--       require("noice").enable()
--     end, 1000)  -- Waktu tunggu dalam milidetik (1000 ms = 1 detik)
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.textwidth = 72
        vim.opt_local.colorcolumn = "51,73"
        vim.opt_local.formatoptions:append("t") -- auto wrap saat nulis
    end,
})
