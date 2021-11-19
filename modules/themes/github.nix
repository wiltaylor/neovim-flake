{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.theme.github;
in {

  options.vim.theme.github = {
    enable = mkEnableOption "Enable github theme";
  };

  config = mkIf (cfg.enable) 
  (let
    mkVimBool = val: if val then "1" else "0";
  in {
    vim.configRC = ''
      colorscheme github_light
    '';

    vim.startPlugins = with pkgs.neovimPlugins; [github-theme];
  });
}
