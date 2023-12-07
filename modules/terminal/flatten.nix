{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
	cfg = config.vim.terminal.flatten;
in {
	options.vim.terminal.flatten = {
		enable = mkEnableOption "flatten";
	};

	config = mkIf (cfg.enable) ({
		vim.startPlugins = with pkgs.neovimPlugins; [
			flatten
		];

		vim.luaConfigRC = ''
            require("flatten").setup({
            	window = {
            		open = "vsplit",
            		focus = "first",
            	}
            })
            '';
	});
}



