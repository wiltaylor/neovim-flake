{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.git;
in {
  options.vim.git = {
    enable =  mkEnableOption "Enable git support"; 
  };

  config = mkIf cfg.enable {

    vim.startPlugins = with pkgs.neovimPlugins; [ 
      fugitive
    ];
  };
}

