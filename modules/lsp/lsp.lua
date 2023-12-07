local wk		= require("which-key")
local lspconfig = require'lspconfig'
local dap       = require'dap'
local null_ls	= require("null-ls")

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

null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.gomodifytags,

		null_ls.builtins.code_actions.shellcheck,               -- https://www.shellcheck.net/

		null_ls.builtins.diagnostics.codespell.with({
			extra_args = {
				"-I",
				vim.fn.expand("~/.config/nvim/codespell-ignore"),
			},
		}),

		null_ls.builtins.diagnostics.staticcheck,				-- https://github.com/dominikh/go-tools
		null_ls.builtins.formatting.fixjson,                    -- https://github.com/rhysd/fixjson
		null_ls.builtins.formatting.goimports_reviser,          -- https://pkg.go.dev/github.com/incu6us/goimports-reviser
		null_ls.builtins.formatting.markdown_toc,               -- https://github.com/jonschlinkert/markdown-toc
		null_ls.builtins.formatting.mdformat,                   -- https://github.com/executablebooks/mdformat
		null_ls.builtins.formatting.shfmt,                      -- https://github.com/mvdan/sh
		null_ls.builtins.formatting.yamlfmt                     -- https://github.com/google/yamlfmt
	}
})

