local wk		= require("which-key")
local gitsigns	= require("gitsigns")
local neogit	= require("neogit")
local diffview	= require("diffview")
local gitlab	= require("gitlab")

-- git signs
gitsigns.setup({
	signs = {
		add				= { text = '│' },
		change			= { text = '│' },
		delete			= { text = '_' },
		topdelete		= { text = '‾' },
		changedelete	= { text = '~' },
		untracked		= { text = '┆' },
	},
	signcolumn			= true,
	numhl				= false,
	linehl				= false,
	word_diff			= false,
	watch_gitdir = {
		interval		= 1000,
		follow_files	= true
	},
	attach_to_untracked	= true,
	current_line_blame	= false,

	sign_priority		= 6,
	update_debounce		= 100,
	status_formatter	= nil, -- Use default
	max_file_length		= 80000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border			= 'single',
		style			= 'minimal',
		relative		= 'cursor',
		row				= 0,
		col				= 1
	},
	yadm = {
		enable			= false
	},
})

-- Neogit (Margit for neovim)
neogit.setup({})

-- Git bindings using <leader>g in a group
wk.register({
	["<leader>g"] = {
		name = "Git",

		s = { ":Neogit<CR>",		"git status"			},
		S = { ":Telescope git_status<CR>",
									"git status (telescope)"},
		p = { ":G pull<CR>",		"git pull"				},
		P = { ":G push<CR>",		"git push"				},
		d = { ":Gdiffsplit<CR>",	"git diff (split)"		},
		b = { ":G blame<CR>",		"git blame"				},
		l = { ":Gclog<CR>",			"git log"				},
		r = { ":Gread<CR>",			"git checkout --"		},
		a = { ":Gwrite<CR>",		"git add"				},
		B = { ":GBrowse<CR>",		"Open in browser"		},
		h = { ":Telescope git_bcommits<CR>",
									"git commit history for this buffer"},
		H = { ":Telescope git_commits<CR>",
									"git commit history for all files"},
	}
}, { mode = "n", silent = true })

-- Gitlab
diffview.setup({})

gitlab.setup({
	reviewer = "diffview",
	popup = {
		exit = "<Esc>",
		perform_action = "<leader>s",
		perform_linewise_action = "<enter>",
	},
})

-- Gitlab bindings using <leader>l in a group
wk.register({
	["<leader>l"] = {
		name = "Gitlab",

		r = { gitlab.review,				"Review" },
		s = { gitlab.summary,				"Summary" },
		A = { gitlab.approve,				"Approve" },
		R = { gitlab.revoke,				"Revoke" },
		c = { gitlab.create_comment,		"Comment" },
		n = { gitlab.create_note,			"Add Note" },
		d = { gitlab.toggle_discussions,	"Toggle Discussions" },
		aa= { gitlab.add_assignee,			"Add Assignee" },
		ad= { gitlab.delete_assignee,		"Delete Assignee" },
		ra= { gitlab.add_reviewer,			"Add Reviewer" },
		rd= { gitlab.delete_reviewer,		"Delete Reviewer" },
		p = { gitlab.pipeline,				"Pipeline" },
		o = { gitlab.open_in_browser,		"Open in Browser" },
	}
}, { mode = "n", silent = true })

