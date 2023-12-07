{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
	cfg = config.vim.git;
in {
	options.vim.git = {
		enable			=  mkEnableOption "Git support"; 
		blameLine = mkOption {
			default		= true;
			description	= "Prints blame info of who edited the line you are on.";
			type		= types.bool;
		};
	};

	config = mkIf cfg.enable {
		vim.startPlugins = with pkgs.neovimPlugins; [
			fugitive
			fugitive-gitlab
			nvim-telescope
			gitsigns
			plenary-nvim
			neogit

			(if cfg.blameLine then nvim-blame-line else null)
		];

		vim.luaConfigRC = builtins.readFile ./git.lua;

		vim.configRC = ''
			${if cfg.blameLine then "autocmd BufEnter * EnableBlameLine" else ""}
		'';
	};
}

