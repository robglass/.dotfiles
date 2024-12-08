return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    proirity = 1000,
    config = function()
        require("catppuccin").setup({
            flavor = "mocha",
            transparent_background = false,
            dim_inactive = {
                enabled = false,
                shade = "light",
                percentage = 0.9,
            },
            custom_hightlights = function(colors)
                local searchActive = { bg = colors.red, fg = "#181825" }
                local searchInactive = { bg = colors.peach, fg = "#000000" }
                return {
                    CursorLineNr = { fg = colors.flamingo },
                    Search = searchInactive,
                    IncSearch = searchActive,
                    EndOfBuffer = { fg = colors.flamingo },
                    WinSeperator = { fg = colors.surface0, bg = colors.surface0 },
                }
            end,
        })

        vim.cmd([[colorscheme catppuccin]])
    end
}
