{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
  cfg = config.vim;
in {
  options.vim = {
    colourTerm = mkOption {
      default = true;
      description = "Set terminal up for 256 colours";
      type = types.bool;
    };

    disableArrows = mkOption {
      default = false;
      description = "Set to prevent arrow keys from moving cursor";
      type = types.bool;
    };
  };

  config = {
    
    vim.nmap = if (cfg.disableArrows) then {
      "<up>" = "<nop>";
      "<down>" = "<nop>";
      "<left>" = "<nop>";
      "<right>" = "<nop>";
    } else {};

    vim.imap = if (cfg.disableArrows) then {
      "<up>" = "<nop>";
      "<down>" = "<nop>";
      "<left>" = "<nop>";
      "<right>" = "<nop>";
    } else {};

    vim.configRC = ''

    '' + (if cfg.colourTerm then ''
      set termguicolors
      set t_Co=256
    '' else "");
  };
}
