{pkgs, config, lib, ...}:
with builtins;
with lib;
let
  cfg = config.vim.dashboard.startify;

  mkVimBool = val: if val then "1" else "0";

  buildBookmarks = list: concatStringsSep "," (map (l: "{'${l.key}': '${l.path}'}") list);
  buildHeader = list: concatStringsSep "," (map (l: "'${l}'") list);
  buildList = list: concatStringsSep "," (map (l: "{ 'type': '${l.type}', 'header': ['${l.header}']}") list);

in {
  options.vim.dashboard.startify = {
    enable = mkEnableOption "Enable startify";

    bookmarks = mkOption {
      default = [];
      description = ''List of book marks to disaply on start page'';
      type = with types; listOf attrs;
      example = { key = "c"; path = "~/.vimrc"; };
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

    Lists = mkOption {
      default = [
        { type = "files"; header = "MRU"; }
        { type = "dir"; header = "MRU Current Directory"; }
        { type = "sessions"; header = "Sessions"; }
        { type = "bookmarks"; header = "Bookmarks"; }
        { type = "commands"; header = "Commands"; }
      ];
      description = "Specify the lists and in what order they are displayed on startify.";
      type = with types; listOf attrs;
    };

  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [vim-startify];

    vim.configRC = ''
      let g:startify_bookmarks = [${buildBookmarks cfg.bookmarks}]
      let g:startify_custom_header = [${buildHeader cfg.customHeader}]
      let g:startify_lists = [${buildList cfg.Lists}]
    '';

    vim.globals = {
      "startify_change_to_dir" = mkVimBool cfg.changeToDir;
      "startify_change_to_vcs_root" = mkVimBool cfg.changeToVCRoot;
      "startify_change_cmd" = cfg.changeDirCmd;

    };


  };
}
