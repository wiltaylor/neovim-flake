{
  description = "Wil Taylor's NeoVim config";

  inputs = { 
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Vim plugins
    gruvbox = { url = "github:morhetz/gruvbox"; flake = false; };
    nord-vim = { url = "github:arcticicestudio/nord-vim"; flake = false;};
    vim-startify = { url = "github:mhinz/vim-startify"; flake = false;};
    lightline-vim = { url = "github:itchyny/lightline.vim"; flake = false;};
  };

  outputs = { nixpkgs, flake-utils, neovim, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      plugins = [
        "gruvbox"
        "nord-vim"
        "vim-startify"
        "lightline-vim"
      ]; 

      pluginOverlay = lib.buildPluginOverlay;
      
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true;};
          overlays = [
            pluginOverlay
            (final: prev: {
              neovim-nightly = neovim.defaultPackage.${system};
            })
          ];
        };

      lib = import ./lib { inherit pkgs inputs plugins; };

      neovimBuilder = lib.neovimBuilder; 
      in rec {
        inherit neovimBuilder;

        packs = pkgs;

        defaultPackage = neovimBuilder {
          config = {
            vim.dashboard.startify.enable = true;
            vim.dashboard.startify.customHeader = [ "NIXOS NEOVIM CONFIG" ];
            vim.theme.nord.enable = true;
            vim.disableArrows = true;
            vim.statusline.lightline.enable = true;

          };
        };
      });
}
