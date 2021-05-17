{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic
    ./themes
    ./dashboard
    ./statusline
  ];
}
