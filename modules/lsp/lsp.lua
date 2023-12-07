local wk		= require("which-key")
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

-- LSP Configurations

-- graphql
-- Install with: npm install -g graphql-language-service-cli
lspconfig.graphql.setup{}
lspconfig.gopls.setup{ }

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		show_header = true,
		source = 'any',
		border = 'rounded',
		focusable = false,
	}
})

