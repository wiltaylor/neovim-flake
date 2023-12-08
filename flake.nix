{
	description = "Micah N Gorrell's NeoVim config";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		neovim = {
			url = "github:neovim/neovim?dir=contrib";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		rnix-lsp					= { url = "github:nix-community/rnix-lsp"; };

		# Vim Themes
		nvim-xenon					= { url = "github:minego/nvim-xenon";							flake = false; };
		gruvbox						= { url = "github:morhetz/gruvbox";								flake = false; };
		nord-vim					= { url = "github:arcticicestudio/nord-vim";					flake = false; };

		# Git plugins
		gitsigns					= { url = "github:lewis6991/gitsigns.nvim";						flake = false; };
		fugitive					= { url = "github:tpope/vim-fugitive";							flake = false; };
		fugitive-gitlab				= { url = "github:shumphrey/fugitive-gitlab.vim";				flake = false; };
		nvim-blame-line				= { url = "github:tveskag/nvim-blame-line";						flake = false; };
		neogit						= { url = "github:NeogitOrg/neogit";							flake = false; };

        # Terminal Plugins
		flatten						= { url = "github:willothy/flatten.nvim";						flake = false; };

		vim-startify				= { url = "github:mhinz/vim-startify";							flake = false; };
		lightline-vim				= { url = "github:itchyny/lightline.vim";						flake = false; };
		lualine-nvim				= { url = "github:nvim-lualine/lualine.nvim";					flake = false; };
		nvim-scope					= { url = "github:tiagovla/scope.nvim";							flake = false; };

		nvim-lspconfig				= { url = "github:neovim/nvim-lspconfig";						flake = false; };
		nvim-lsp-smag				= { url = "github:weilbith/nvim-lsp-smag";						flake = false; };
		lsp_signature				= { url = "github:ray-x/lsp_signature.nvim";					flake = false; };
		null-ls						= { url = "github:jose-elias-alvarez/null-ls.nvim";				flake = false; };

		vim-nix						= { url = "github:LnL7/vim-nix";								flake = false; };
		nvim-dap					= { url = "github:mfussenegger/nvim-dap";						flake = false; };
		nvim-telescope				= { url = "github:nvim-telescope/telescope.nvim";				flake = false; };
		nvim-telescope-emoji		= { url = "github:xiyaowong/telescope-emoji.nvim";				flake = false; };
		nvim-telescope-dap			= { url = "github:nvim-telescope/telescope-dap.nvim";			flake = false; };
		popup-nvim					= { url = "github:nvim-lua/popup.nvim";							flake = false; };
		plenary-nvim				= { url = "github:nvim-lua/plenary.nvim";						flake = false; };
		nvim-web-devicons			= { url = "github:kyazdani42/nvim-web-devicons";				flake = false; };
		nvim-tree-lua				= { url = "github:kyazdani42/nvim-tree.lua";					flake = false; };
		nvim-lightbulb				= { url = "github:kosayoda/nvim-lightbulb";						flake = false; };
		editorconfig-vim			= { url = "github:editorconfig/editorconfig-vim";				flake = false; };
		nvim-dap-virtual-text		= { url = "github:theHamsta/nvim-dap-virtual-text";				flake = false; };
		vim-cursorword				= { url = "github:itchyny/vim-cursorword";						flake = false; };
		vim-test					= { url = "github:vim-test/vim-test";							flake = false; };
		nvim-which-key				= { url = "github:folke/which-key.nvim";						flake = false; };
		indent-blankline-nvim		= { url = "github:lukas-reineke/indent-blankline.nvim";			flake = false; };
		nvim-navic					= { url = "github:SmiteshP/nvim-navic";							flake = false; };
		nvim-treesitter-context		= { url = "github:nvim-treesitter/nvim-treesitter-context";		flake = false; };
		nvim-treesitter-textobjects	= { url = "github:nvim-treesitter/nvim-treesitter-textobjects"; flake = false; };
		nvim-osc52					= { url = "github:ojroques/nvim-osc52";							flake = false; };

		nui-nvim					= { url = "github:MunifTanjim/nui.nvim";						flake = false; };
		dressing-nvim				= { url = "github:stevearc/dressing.nvim";						flake = false; };
		diffview-nvim				= { url = "github:sindrets/diffview.nvim";						flake = false; };

		# Build as a flake to build the go server as well
		gitlab						= { url = "./flakes/gitlab-nvim-flake";							flake = true; };

# My additions

		nvim-dap-ui					= { url = "github:rcarriga/nvim-dap-ui";						flake = false; };

		neotest						= { url = "github:nvim-neotest/neotest";						flake = false; };
		neotest-go					= { url = "github:nvim-neotest/neotest-go";						flake = false; };

		nvim-dap-go					= { url = "github:leoluz/nvim-dap-go";							flake = false; };
		goimpl						= { url = "github:edolphin-ydf/goimpl.nvim";					flake = false; };
		vim-go-coverage				= { url = "github:kyoh86/vim-go-coverage";						flake = false; };

		vim-rest-console			= { url = "github:diepm/vim-rest-console";						flake = false; };

	};

	outputs = { self, nixpkgs, neovim, rnix-lsp, ... }@inputs:
	let
		plugins = [
			"nvim-xenon"
			"gruvbox"
			"nord-vim"

			"gitsigns"
			"fugitive"
			"fugitive-gitlab"
			"nvim-blame-line"
			"neogit"

            "flatten"

			"vim-startify"
			"lightline-vim"
			"lualine-nvim"
			"nvim-scope"

			"nvim-lspconfig"
			"nvim-lsp-smag"
			"lsp_signature"
			"null-ls"

			"completion-nvim"
			"vim-nix"
			"nvim-dap"
			"nvim-telescope"
			"nvim-telescope-dap"
			"nvim-telescope-emoji"
			"popup-nvim"
			"plenary-nvim"
			"nvim-web-devicons"
			"nvim-tree-lua"
			"nvim-lightbulb"
			"nvim-treesitter-context"
			"nvim-treesitter-textobjects"
			"editorconfig-vim"
			"indent-blankline-nvim"
			"nvim-dap-virtual-text"
			"vim-cursorword"
			"vim-test"
			"nvim-which-key"
			"nvim-navic"
			"nvim-osc52"

			"nui-nvim"
			"dressing-nvim"
			"diffview-nvim"
		];

		externalPackages = top: last: {
			rnix-lsp		= rnix-lsp.defaultPackage.${top.system};
			neovim-nightly	= neovim.defaultPackage.${top.system};
		};

		pluginOverlay = top: last:
		let
			buildPlug = name: top.vimUtils.buildVimPlugin {
				pname	= name;
				version	= "master";
				src		= builtins.getAttr name inputs;
			};
		in {
			neovimPlugins = builtins.listToAttrs (map (name: {
				inherit name;

				value = buildPlug name;
			}) plugins);
		};

		allPkgs = lib.mkPkgs {
			inherit nixpkgs; 

			overlays = [
				pluginOverlay
				inputs.gitlab.overlay
				externalPackages
			];
		};

		lib = import ./lib;

		mkNeoVimPkg = pkgs: lib.neovimBuilder {
			inherit pkgs;

			config.vim = {
				neovimPackage					= pkgs.neovim-nightly;

				viAlias							= true;
				vimAlias						= true;
				useSystemClipboard				= true;
				mapLeaderSpace					= false;

				terminal = {
					flatten.enable				= true;
				};

				dashboard = {
					startify.enable				= true;
					startify.customHeader		= [ "MICAH'S NEOVIM" ];
				};

				tabWidth						= 4;
				autoIndent						= false;

				theme = {
					xenon.enable				= true;
					nord.enable					= false;
					gruvbox.enable				= false;
				};

				disableArrows					= true;

				statusline = {
					lightline.enable			= false;
					lualine.enable				= true;
				};

				lsp = {
					enable						= true;
					bash						= true;
					go							= true;
					nix							= true;
					python						= true;
					ruby						= true;
					rust						= true;
					terraform					= true;
					typescript					= true;
					vimscript					= true;
					yaml						= true;
					docker						= true;
					tex							= true;
					css							= true;
					html						= true;
					json						= true;
					clang						= true;
					lightbulb					= true;
					variableDebugPreviews		= true;
				};
				fuzzyfind.telescope.enable		= true;

				git.enable						= true;
				git.blameLine		            = false;

				formatting.editorConfig.enable	= true;

				editor = {
					indentGuide					= true;
					underlineCurrentWord		= true;
				};
				test.enable						= true;
			};
		};
	in {
		apps = lib.withDefaultSystems (sys: {
			nvim = {
				type	= "app";
				program	= "${self.defaultPackage."${sys}"}/bin/nvim";
			};
		});

		defaultApp = lib.withDefaultSystems (sys: {
			type		= "app";
			program		= "${self.defaultPackage."${sys}"}/bin/nvim";
		});

		defaultPackage	= lib.withDefaultSystems (sys: self.packages."${sys}".neovim-minego);

		packages = lib.withDefaultSystems (sys: rec {
			neovim-minego = mkNeoVimPkg allPkgs."${sys}";
		});
	};
}
