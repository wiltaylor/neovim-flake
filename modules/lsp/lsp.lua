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
	indent = {
		enable					= false,
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

	textobjects = {
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist

			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@function.outer",
				-- ["]]"] = { query = "@class.outer", desc = "Next class start" },
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@function.outer",
				-- ["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@function.outer",
				-- ["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@function.outer",
				-- ["[]"] = "@class.outer",
			},
		},
	},
}

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

vim.cmd [[ hi link TreesitterContext StatusLine ]]


