return {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    config = function()
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                on_attach = function(client, bufnr)
                    vim.lsp.inlay_hint.enable(true)
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {},
                },
            },
            -- DAP configuration
            dap = {},
            -- Enable build script support
            cargo = {
                buildScripts = { enable = true },
            },
            -- Enable more Rust-analyzer features
            procMacro = { enable = true },
        }
    end,
}

-- return {
--   "mrcjkb/rustaceanvim",
--   version = "^5",
--   lazy = false,
--   ["rust-analyzer"] = {
--     cargo = {
--       allFeatures = true
--     }
--   }
-- }
