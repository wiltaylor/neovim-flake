{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.vim.fuzzyfind.telescope;
in {
    options.vim.fuzzyfind.telescope = {
        enable = mkEnableOption "Enable telescope";
    };

    config = mkIf cfg.enable {
        vim.startPlugins = with pkgs.neovimPlugins; [
            nvim-telescope
			nvim-telescope-emoji
            popup-nvim
            plenary-nvim
        ];

        vim.luaConfigRC = builtins.readFile ./telescope.lua;
    };
}
