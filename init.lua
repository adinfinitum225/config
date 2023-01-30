--
-- neovim ui settings
--
vim.opt.number = true

--
--Start of LSP and autocomplete configuration
--
require('packer').startup(function(use)

	use 'wbthomason/packer.nvim' -- Main Package manager
	use 'williamboman/mason.nvim' -- LSP package manager
	use 'williamboman/mason-lspconfig.nvim' -- Bridge between mason and lspconfig
	use 'neovim/nvim-lspconfig' -- Configuration for LSP server capabilities
	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	use 'L3MON4D3/LuaSnip' -- Snippets plugin
	use 'folke/tokyonight.nvim' -- Color Scheme
end)

-- Setup Mason and set icons for package status
require('mason').setup({
	ui = {
		icons = {
			package_installed='Y',
			package_pending='O',
			package_uninstalled='N',
		}
	}
})
require('mason-lspconfig').setup()

-- Configuration for Tokyo Night color Scheme
require('tokyonight').setup({})
-- Start Tokyo Night
vim.cmd[[colorscheme tokyonight]]

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Needs to be before any reference to lspconfig. It worked before, but it should be a bit farther up
local lspconfig = require('lspconfig')

-- Possible dynamic setup of servers. Lua worked but HTML didn't work

require('mason-lspconfig').setup_handlers {
	function (server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
		}
	end,
	['html'] = function ()
		lspconfig.html.setup {
			capabilities = capabilities,
			opts = {
				settings = {
					html = {
						autoClosingTags = true,
						format = {
							templating = true,
						},
						hover = {
							documentation = true,
						},
					},
				},
			},
		}
	end,
}

-- Enable servers with extra completion capabilities, supposedly
--local servers = { 'sumneko_lua', 'html', 'cssls' }
--for _, lsp in ipairs(servers) do
----	lspconfig[lsp].setup {
--		capabilities = capabilities,
--	}
--end

-- Setup luasnip
local luasnip = require 'luasnip'

-- Setup nvim-cmp
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, {'i', 's'}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then

				luasnip.jump(-1)
			else
				fallback()
			end
		end, {'i', 's'}),
	}),
	sources = {
		{name='nvim_lsp'},
		{name='luasnip'},
	},
}

