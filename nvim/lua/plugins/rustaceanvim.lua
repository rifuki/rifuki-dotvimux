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
                    vim.lsp.inlay_hint.enable(false)
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        inlayHints = {
                            bindingModeHints = { enable = true },
                            chainingHints = { enable = true },
                            closingBraceHints = { enable = true, minLines = 25 },
                            lifetimeElisionHints = { enable = true, useParameterNames = true },
                            parameterHints = { enable = true },
                            typeHints = { enable = true },
                        },
                    },
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
