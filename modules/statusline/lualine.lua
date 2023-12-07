local navic = require("nvim-navic")

navic.setup({
	icons = {
		File			= ' ',
		Module			= ' ',
		Namespace		= ' ',
		Package			= ' ',
		Class			= ' ',
		Method			= ' ',
		Property		= ' ',
		Field			= ' ',
		Constructor		= ' ',
		Enum			= ' ',
		Interface		= ' ',
		Function		= ' ',
		Variable		= ' ',
		Constant		= ' ',
		String			= ' ',
		Number			= ' ',
		Boolean			= ' ',
		Array			= ' ',
		Object			= ' ',
		Key				= ' ',
		Null			= ' ',
		EnumMember		= ' ',
		Struct			= ' ',
		Event			= ' ',
		Operator		= ' ',
		TypeParameter	= ' '
	},
	highlight			= false,
	separator			= " > ",
	depth_limit			= 0,
	depth_limit_indicator= "..",
	safe_output			= true
})

-- This doesn't actually do anything, except to provide a click target
local function tabswitcher()
	return [[]]
end

local function codecontext()
	if navic.is_available() then
		return navic.get_location()
	end
end

require('lualine').setup {
	options = {
		icons_enabled			= true,
		theme					= 'auto',
		component_separators	= { left = '', right = ''},
		section_separators		= { left = '', right = ''},
		disabled_filetypes		= {
			statusline			= {},
			winbar				= {},
		},
		ignore_focus			= {},
		always_divide_middle	= true,
		globalstatus			= true,
		refresh = {
			statusline			= 1000,
			tabline				= 1000,
			winbar				= 1000,
		}
	},
	sections = {
		lualine_a				= { { 'mode', fmt = function(str) return str:sub(1,1) end } },
		lualine_b = {
			{
				'branch',
				on_click = function()
					require('telescope.builtin').git_branches()
				end
			}, 'diff',
			{
				'diagnostics',
				on_click = function()
					require('telescope.builtin').diagnostics()
				end
			},
		},
		lualine_c = {
			{
				'filename',
				on_click = function()
					require('telescope.builtin').buffers()
				end
			},
			{
				codecontext,
				on_click = function()
					require('telescope.builtin').lsp_document_symbols()
				end
			},
		},
		lualine_x				= {'encoding', 'fileformat', { 'filetype', colored = false }},
		lualine_y				= {'progress'},
		lualine_z				= {'location'}
	},
	tabline = {
		lualine_a = {{
			tabswitcher,
			on_click = function()
				require('telescope-tabs').list_tabs()
			end
		}},
		lualine_b = {
			{
				'tabs',
				mode			= 2, -- Show number and name
				max_length		= 1000,
				tabs_color = {
					active		= 'TabLine',
					inactive	= 'TabLineSel',
				},
			}
		},
		lualine_z = { { 'hostname' } }
	},
	winbar						= {},
	inactive_winbar				= {},
	extensions					= {}
}

-- Hide the default vim mode since it is shown in the bar above
vim.o.showmode = false

local wk = require("which-key")
local modes = {
	[1] = "n",
	[2] = "i",
	[3] = "v",
	[4] = "t",
}

-- Bind these for all modes
-- Note: <c-\\><c-n> is used to ensure we can go back to normal mode
-- even if we start in terminal mode
for _, mode in ipairs(modes) do
	wk.register({
		["<C-a>"] = {
			name = "Tabs",

			["<tab>"]	= { function()
								require('telescope-tabs').list_tabs()
							end,							"list"				},
			a			= { "<c-\\><c-n>g<tab>",			"toggle"			},
			["<C-a>"]	= { "<c-\\><c-n>g<tab>",			"toggle"			},

			-- The $ in $tabnew causes it to be created at the end
			-- The global working dir is returned with `getcwd(-1, -1)` and
			-- that need to be set for each new tab or it will have the working
			-- directory of the tab that created it
			C			= { "<c-\\><c-n>:$tabnew<CR>:call chdir(getcwd(-1, -1))<CR>",
														"create"				},
			c			= { "<c-\\><c-n>:$tabnew<CR>:call chdir(getcwd(-1, -1))<CR>:term<CR>",
														"create terminal"		},
			x			= { "<c-\\><c-n>:tabclose<CR>",	"close"					},
			n			= { "<c-\\><c-n>:tabn<CR>",		"next"					},
			p			= { "<c-\\><c-n>:tabp<CR>",		"prev"					},
			N			= { "<c-\\><c-n>:+tabmove<CR>",	"swap with next"		},
			P			= { "<c-\\><c-n>:-tabmove<CR>",	"swap with prev"		},

			[","]		= { "<c-\\><c-n>:LualineRenameTab ",
														"rename", silent = false},

			["1"]		= { "<c-\\><c-n>1gt",			"go to tab 1"			},
			["2"]		= { "<c-\\><c-n>2gt",			"go to tab 2"			},
			["3"]		= { "<c-\\><c-n>3gt",			"go to tab 3"			},
			["4"]		= { "<c-\\><c-n>4gt",			"go to tab 4"			},
			["5"]		= { "<c-\\><c-n>5gt",			"go to tab 5"			},
			["6"]		= { "<c-\\><c-n>6gt",			"go to tab 6"			},
			["7"]		= { "<c-\\><c-n>7gt",			"go to tab 7"			},
			["8"]		= { "<c-\\><c-n>8gt",			"go to tab 8"			},
			["9"]		= { "<c-\\><c-n>9gt",			"go to tab 9"			},
			["0"]		= { "<c-\\><c-n>0gt",			"go to tab 0"			},
		}
	}, { mode = mode, silent = true })
end

-- Make buffer scoped to tabs
require("scope").setup({})

