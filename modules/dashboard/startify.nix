{pkgs, config, lib, ...}:
with builtins;
with lib;
let
  cfg = config.vim.dashboard.startify;

  mkVimBool = val: if val then "1" else "0";

in {
  options.vim.dashboard.startify = {
    enable = mkEnableOption "Enable startify";

    bookmarks = mkOption {
      default = [];
      description = ''List of book marks to disaply on start page'';
      type = with types; listOf attrs;
      example = { "c" = "~/.vimrc"; };
    };

    changeToDir = mkOption {
      default = true;
      description = "Should vim change to the directory of the file you open";
      type = types.bool;
    };

    changeToVCRoot = mkOption {
      default = false;
      description = "Should vim change to the version control root when opening a file";
      type = types.bool;
    };

    changeDirCmd = mkOption {
      default = "lcd";
      description = "Command to change the current window with. Can be cd, lcd or tcd";
      type = types.enum ["cd" "lcd" "tcd"];
    };

    customHeader = mkOption {
      default = [];
      description = "Text to place in the header";
      type = with types; listOf str;
    };

    customFooter = mkOption {
      default = [];
      description = "Text to place in the footer";
      type = with types; listOf str;
    };

    lists = mkOption {
      default = [
        { type = "files"; header = ["MRU"]; }
        { type = "dir"; header = ["MRU Current Directory"]; }
        { type = "sessions"; header = ["Sessions"]; }
        { type = "bookmarks"; header = ["Bookmarks"]; }
        { type = "commands"; header = ["Commands"]; }
      ];
      description = "Specify the lists and in what order they are displayed on startify.";
      type = with types; listOf attrs;
    };

    skipList = mkOption {
      default = [];
      description = "List of regex patterns to exclude from MRU lists";
      type = with types; listOf str;
    };

    updateOldFiles = mkOption {
      default = false;
      description = "Set if you want startify to always update and not just when neovim closes";
      type = types.bool;
    };

    sessionAutoload = mkOption {
      default = false;
      description = "Make startify auto load Session.vim files from the current directory";
      type = types.bool;
    };

    commands = mkOption {
      default = [];
      description = "Commands that are presented to the user on startify page";
      type = with types; listOf (oneOf[str attrs (listOf str)]);
    };

    filesNumber = mkOption {
      default = 10;
      description = "How many files to list";
      type = types.int;
    };
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [vim-startify];
    
    vim.globals = {
      "startify_custom_header" = if cfg.customHeader == [] then null else cfg.customHeader;
      "startify_custom_footer" = if cfg.customFooter == [] then null else cfg.customFooter;
      "startify_bookmarks" = cfg.bookmarks;
      "startify_lists" = cfg.lists;
      "startify_change_to_dir" = mkVimBool cfg.changeToDir;
      "startify_change_to_vcs_root" = mkVimBool cfg.changeToVCRoot;
      "startify_change_cmd" = cfg.changeDirCmd;
      "startify_skiplist" = cfg.skipList;
      "startify_update_oldfiles" = mkVimBool cfg.updateOldFiles;
      "startify_session_autoload" = mkVimBool cfg.sessionAutoload;
      "startify_commands" = cfg.commands;
      "startify_files_number" = cfg.filesNumber;
    };


  };
}
