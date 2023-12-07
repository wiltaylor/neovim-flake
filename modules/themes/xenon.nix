{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
	cfg = config.vim.theme.xenon;
in {
	options.vim.theme.xenon = {
		enable = mkEnableOption "xenon theme";
	};

	config = mkIf (cfg.enable) (
	let
		mkVimBool = val: if val then "1" else "0";
	in {
		vim.luaConfigRC = ''
			vim.opt.background = "dark"
			vim.cmd.colorscheme "xenon"
		'';

		vim.startPlugins = with pkgs.neovimPlugins; [
			nvim-xenon
		];
	});
}
