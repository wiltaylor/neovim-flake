{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
	cfg = config.vim.formatting.editorConfig;
in {
	options.vim.formatting.editorConfig = {
		enable = mkEnableOption "Editor Config";
	};

	config = mkIf cfg.enable {
		vim.startPlugins = with pkgs.neovimPlugins; [ 
			editorconfig-vim
		];
	};
}


