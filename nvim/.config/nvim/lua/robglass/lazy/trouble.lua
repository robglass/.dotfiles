return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                auto_open = false,
                auto_close = false,
                auto_preview = true,
                auto_jump = {},
                mode = "quickfix",
                severity = vim.diagnostic.severity.ERROR,
                cycle_results = false,
            })

            vim.keymap.set("n", "<leader>tt", function()
                require("trouble").toggle()
            end)

            vim.keymap.set("n", "[t", function()
                require("trouble").next({ skip_groups = true, jump = true });
            end)

            vim.keymap.set("n", "]t", function()
                require("trouble").previous({ skip_groups = true, jump = true });
            end)

            vim.api.nvim_create_autocmd("User", {
                pattern = { "XcodebuildBuildFinished", "XcodebuildTestsFinished" },
                callback = function(event)
                    if event.data.cancelled then
                        return
                    end

                    if event.data.success then
                        require("trouble").close()
                    elseif not event.data.failedCount or event.data.failedCount > 0 then
                        if next(vim.fn.getqflist()) then
                            require("trouble").open({ focus = false })
                        else
                            require("trouble").close()
                        end

                        require("trouble").refresh()
                    end
                end,
            })
        end
    },
}
