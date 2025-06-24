-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

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

-- Autocmd: Set filetype yaml.github-actions untuk workflow
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".github/workflows/*.yml", ".github/workflows/*.yaml" },
  callback = function()
    vim.bo.filetype = "yaml.github-actions"
  end,
})

-- LSP for workflow GitHub Actions
lspconfig.gh_actions_ls.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "yaml.github-actions" },
  settings = {
    diagnostics = {
      enable = true,
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

-- Deno LSP
lspconfig.denols.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  single_file_support = false,
})

-- TypeScript/JavaScript
lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    -- Disable formatting for ts_ls to avoid handle TSX
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  single_file_support = false,
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
  filetypes = { "css", "typescriptreact", "javascriptreact" },
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})
