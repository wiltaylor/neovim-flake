{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic
    ./themes
    ./statusline
    ./lsp
    ./fuzzyfind
    ./git
    ./formating
    ./editor
    ./test
  ];
}
