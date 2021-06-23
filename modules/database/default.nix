{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.database;
in {
  options.vim.database = {
    enable = mkEnableOption "Enable database support";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ 
      vim-dadbod-ui
      vim-dadbod
    ];
  };
}
