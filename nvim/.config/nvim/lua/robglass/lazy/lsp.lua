return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "tsserver",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        local lspconfig = require("lspconfig")
        lspconfig.sourcekit.setup({
            capabilities = {
                workspace = {
                    didChangeConfiguration = {
                        dynamicRegistration = true,
                    },
                },
            },
            on_attach = function(_, bufnr)
                vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "U<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>gh", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>gw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>[g", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>]g", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { buffer = bufnr })
            end,
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
