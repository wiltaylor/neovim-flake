local wk		= require("which-key")
local telescope	= require('telescope')

wk.register({
	["<leader>f"] = {
		name	= "find files",

		f		= { "<cmd>Telescope find_files<CR>",			"find files"			},
		g		= { "<cmd>Telescope live_grep<CR>",				"live grep"				},
		b		= { "<cmd>Telescope buffers<CR>",				"buffers"				},
		h		= { "<cmd>Telescope help_tags<CR>",				"help"					},
		G		= { "<cmd>Telescope git_files<CR>",				"git files"				},
		r		= { "<cmd>Telescope lsp_references<CR>",		"LSP references"		},
		i		= { "<cmd>Telescope lsp_implementations<CR>",	"LSP implementations"	},
		o		= { "<cmd>Telescope lsp_document_symbols<CR>",	"LSP document symbols"	},
		D		= { "<cmd>Telescope lsp_definitions<CR>",		"LSP definitions"		},
		d		= { "<cmd>Telescope diagnostics<CR>",			"diagnostics"			},
		q		= { "<cmd>Telescope quickfix<CR>",				"quickfix"				},
		s		= { "<cmd>Telescope git_stash<CR>",				"git stash"				},
		B		= { "<cmd>Telescope git_branches<CR>",			"git branches"			},

		m		= { "<cmd>Telescope man_pages<CR>",				"man pages"				},
	},
},  { mode = "n" })

wk.register({ ["<c-k>"] = { "<cmd>Telescope buffers<CR>",		"buffers"				} })
wk.register({ ["z="]    = { "<cmd>Telescope spell_suggest<CR>",	"Show spelling suggestsions" } }, { mode = "n", silent = true })

wk.register({
	["<leader>f"] = {
		e		= { "<cmd>Telescope emoji<CR>",					"emoji"			},
	},
},  { mode = "n" })

telescope.setup{}
telescope.load_extension('emoji')

