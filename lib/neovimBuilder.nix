{ pkgs, lib ? pkgs.lib, ...}:

{ config }:
let
  neovimPlugins = pkgs.neovimPlugins;

  vimOptions = lib.evalModules {
    modules = [
      { imports = [../modules]; }
      config 
    ];

    specialArgs = {
      inherit pkgs; 
    };
  };

  vim = vimOptions.config.vim;
in 
  pkgs.wrapNeovim pkgs.neovim-nightly {
    vimAlias = true;
    viAlias = true;
    configure = {
      customRC = vim.configRC;

     packages.myVimPackage = {
        start = vim.startPlugins;
        opt = vim.optPlugins;
      };
    };
  }

