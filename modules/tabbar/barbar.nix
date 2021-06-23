{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.tabbar.barbar;

in {

  options.vim.tabbar.barbar = {
    enable = mkEnableOption "Enable barbar";

  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ 
      barbar-nvim
    ];
  };
}


