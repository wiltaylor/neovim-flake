{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.lsp;
in {

  options.vim.lsp = {
    enable = mkEnableOption "Enable lsp support";

    bash = mkEnableOption "Enable Bash Language Support";

  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-lspconfig ];

    # ["${pkgs.nodePackages.bash-language-server}/bin/bash-language-server" "start"];

    vim.luaConfigRC = ''
      ${if cfg.bash then ''
        require'lspconfig'.bashls.setup{
          cmd = {"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start"}
        }
      '' else ""}
    '';
  };
}
