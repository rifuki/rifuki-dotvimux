-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- EXAMPLE
local servers = { "lua_ls", "taplo", "prismals", "dockerls" }
local nvlsp = require("nvchad.configs.lspconfig")

-- lsps with default config
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    })
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
--
-- YAML dengan schema docker-compose (autocompletion di docker-compose.yml)
--

lspconfig.gh_actions_ls.setup({
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    filetypes = { "yaml" },
    settings = {
        diagnostics = {
            enable = false,
        },
    },
    root_dir = function(fname)
        return lspconfig.util.root_pattern(".github/workflows")(fname) or lspconfig.util.find_git_ancestor(fname)
    end,
})

lspconfig.yamlls.setup({
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.yml",
            },
            validate = true,
            completion = true,
            hover = true,
        },
    },
})
-- TypeScript/JavaScript
lspconfig.ts_ls.setup({
    on_attach = function(client, bufnr)
        -- Mencegah `tsserver` menangani fitur HTML di TSX
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        nvlsp.on_attach(client, bufnr)
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
})

-- HTML/TSX (vscode-html-language-server via bun)
lspconfig.html.setup({
    cmd = { vim.fn.expand("~/.bun/bin/vscode-html-language-server"), "--stdio" },
    filetypes = { "html", "typescriptreact", "javascriptreact" },
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
})

-- CSS/TSX (vscode-css-language-server via bun)
lspconfig.cssls.setup({
    cmd = { vim.fn.expand("~/.bun/bin/vscode-css-language-server"), "--stdio" },
    filetypes = { "css", "typescriptreact", "javascriptreact" }, -- Tambahkan ini!
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
})
