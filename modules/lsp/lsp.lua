local wk = require("which-key")
wk.register({
	c = {
		name    = "Code",
		a       = {"Code Action"},
		f       = {"Format"},
		d       = {"Definitions"},
		i       = {"Implementations"},
		R       = {"Rename"},
		r       = {"References"},
		k       = {"Signature"},
	},

	d = {
		name    = "Debug",
		o       = {"Step Over"},
		s       = {"Step Into"},
		O       = {"Step Out"},
		c       = {"Continue"},
		b       = {"Toggle Break Point"},
		r       = {"Debug Repl"},
	},
},{ prefix = "<leader>" })

local lspconfig = require'lspconfig'
local dap       = require'dap'

--Tree sitter config
require('nvim-treesitter.configs').setup {
	highlight = {
		enable                  = true,
		disable                 = {},
	},
	rainbow = {
		enable                  = true,
		extended_mode           = true,
	},
	autotag = {
		enable                  = true,
	},
	context_commentstring = {
		enable                  = true,
	},
	incremental_selection = {
		enable                  = true,
		keymaps = {
			init_selection      = "gnn",
			node_incremental    = "grn",
			scope_incremental   = "grc",
			node_decremental    = "grm",
		},
	},
}

vim.cmd [[set foldmethod=expr]]
vim.cmd [[set foldlevel=10]]
vim.cmd [[set foldexpr=nvim_treesitter#foldexpr()]]


