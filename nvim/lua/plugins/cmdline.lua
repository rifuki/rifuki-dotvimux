return {
    "hrsh7th/cmp-cmdline",
    lazy = false,
    dependencies = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-path", -- Autocomplete path
        "hrsh7th/cmp-cmdline", -- Autocomplete Command Mode
    },
    config = function()
        local cmp = require "cmp"

        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "Man", "!" },
                    },
                },
            }),
        })
    end,
}
