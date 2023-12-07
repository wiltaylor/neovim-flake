{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
	cfg = config.vim.statusline.lualine;
in {
	options.vim.statusline.lualine = {
		enable = mkEnableOption "Lualine";
	};

	config = mkIf (cfg.enable) (
		let 
			lightCfg = {
			};
		in {
			vim.startPlugins = with pkgs.neovimPlugins; [
				lualine-nvim
				nvim-which-key
				nvim-web-devicons
				nvim-telescope
				nvim-navic
				nvim-scope
			];

			vim.globals = {
				"lightline" = lightCfg;
			};

			vim.luaConfigRC = builtins.readFile ./lualine.lua;
		}
	);
}



