return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
        { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",
    opts = {
        -- See Configuration section for options
        mappings = {
            reset = {
                normal = false,
                insert = false,
            },
        },
    },
    -- See Commands section for default commands if you want to lazy load on them
    lazy = false,
    keys = {
        {
            "<leader>cc",
            function()
                require("CopilotChat").toggle()
            end,
            desc = "Toggle CopilotChat",
        },
        {
            "<leader>cq",
            function()
                require("CopilotChat").ask("Explain code")
            end,
            desc = "CopilotChat: Explain code",
            mode = { "n", "v" },
        },
        {
            "<leader>ci",
            function()
                require("CopilotChat").ask("Improve code")
            end,
            desc = "CopilotChat: Improve code",
            mode = { "n", "v" },
        },
        {
            "<leader>cf",
            function()
                require("CopilotChat").ask("Fix code")
            end,
            desc = "CopilotChat: Fix code",
            mode = { "n", "v" },
        },
        {
            "<leader>cd",
            function()
                require("CopilotChat").ask("Debug code")
            end,
            desc = "CopilotChat: Debug code",
            mode = { "n", "v" },
        },
        {
            "<leader>cs",
            function()
                require("CopilotChat").ask("Suggest tests")
            end,
            desc = "CopilotChat: Suggest tests",
            mode = { "n", "v" },
        },
        {
            "<leader>cS",
            function()
                require("CopilotChat").ask("Suggest code")
            end,
            desc = "CopilotChat: Suggest code",
            mode = { "n", "v" },
        },
        {
            "<leader>cC",
            function()
                require("CopilotChat").ask("Translate code")
            end,
            desc = "CopilotChat: Translate code",
            mode = { "n", "v" },
        },
    },
}
