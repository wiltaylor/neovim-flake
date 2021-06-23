{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic
    ./themes
    ./dashboard
    ./statusline
    ./lsp
    ./fuzzyfind
    ./filetree
    ./git
    ./tabbar
    ./formating
    ./editor
    ./database
    ./test
  ];
}
