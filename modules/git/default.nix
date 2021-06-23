{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.git;
in {
  options.vim.git = {
    enable =  mkEnableOption "Enable git support"; 
    blameLine = mkOption {
      default = true;
      description = "Prints blame info of who edited the line you are on.";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    vim.nnoremap = {
      "<leader>g" = "<cmd>MagitOnly<cr>";
    };

    vim.startPlugins = with pkgs.neovimPlugins; [ 
      vimagit 
      fugitive

      (if cfg.blameLine then nvim-blame-line else null)
    ];

    vim.configRC = ''
      ${if cfg.blameLine then ''
        autocmd BufEnter * EnableBlameLine
      '' else ""}
    '';
  };
}

