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
    nord-vim = { url = "github:arcticicestudio/nord-vim"; flake = false; };
    vim-startify = { url = "github:mhinz/vim-startify"; flake = false; };
    lightline-vim = { url = "github:itchyny/lightline.vim"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    completion-nvim = { url = "github:nvim-lua/completion-nvim"; flake = false; };
    vim-nix = { url = "github:LnL7/vim-nix"; flake = false; };
    nvim-dap = { url = "github:mfussenegger/nvim-dap"; flake = false; };
    nvim-telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    telescope-dap = { url = "github:nvim-telescope/telescope-dap.nvim"; flake = false; };
    popup-nvim = { url = "github:nvim-lua/popup.nvim"; flake = false; };
    plenary-nvim = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    nvim-web-devicons = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };
    nvim-tree-lua = { url = "github:kyazdani42/nvim-tree.lua"; flake = false; };
    vimagit = { url = "github:jreybert/vimagit"; flake = false; };
    fugitive = { url = "github:tpope/vim-fugitive"; flake = false; };
    nvim-lightbulb = { url = "github:kosayoda/nvim-lightbulb"; flake = false; };
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false;};
    nvim-treesitter-context = { url = "github:romgrk/nvim-treesitter-context"; flake = false;};
    rnix-lsp.url = github:nix-community/rnix-lsp;
    barbar-nvim = { url = "github:romgrk/barbar.nvim"; flake = false; };
    editorconfig-vim = { url = "github:editorconfig/editorconfig-vim"; flake = false; };
    indentline = { url = "github:Yggdroot/indentLine"; flake = false; };
    indent-blankline-nvim = { url = "github:lukas-reineke/indent-blankline.nvim"; flake = false; };
    nvim-blame-line = { url = "github:tveskag/nvim-blame-line"; flake = false; };
    nvim-dap-virtual-text = { url = "github:theHamsta/nvim-dap-virtual-text"; flake = false; };
    vim-cursorword = { url = "github:itchyny/vim-cursorword"; flake = false; };
    vim-dadbod = { url = "github:tpope/vim-dadbod"; flake = false; };
    vim-dadbod-ui = { url = "github:kristijanhusak/vim-dadbod-ui"; flake = false; };
    vim-hexokinase = { url = "github:RRethy/vim-hexokinase"; flake = false; };
    vim-test = { url = "github:vim-test/vim-test"; flake = false; };
    vim-floaterm = { url = "github:voldikss/vim-floaterm"; flake = false; };
    nvim-which-key = { url = "github:folke/which-key.nvim"; flake = false; };
  };

  outputs = { nixpkgs, flake-utils, neovim, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        plugins = [
          "gruvbox"
          "nord-vim"
          "vim-startify"
          "lightline-vim"
          "nvim-lspconfig"
          "completion-nvim"
          "vim-nix"
          "nvim-dap"
          "nvim-telescope"
          "popup-nvim"
          "plenary-nvim"
          "nvim-web-devicons"
          "nvim-tree-lua"
          "telescope-dap"
          "vimagit"
          "fugitive" 
          "nvim-lightbulb"
          "nvim-treesitter"
          "nvim-treesitter-context"
          "barbar-nvim"
          "editorconfig-vim"
          "indent-blankline-nvim"
          "indentline"
          "nvim-blame-line"
          "nvim-dap-virtual-text"
          "vim-cursorword"
          "vim-dadbod"
          "vim-dadbod-ui"
          "vim-hexokinase"
          "vim-test"
          "vim-floaterm"
          "nvim-which-key"
        ];

        pluginOverlay = lib.buildPluginOverlay;

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [
            pluginOverlay
            (final: prev: {
              neovim-nightly = neovim.defaultPackage.${system};
              rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
            })
          ];
        };

        lib = import ./lib { inherit pkgs inputs plugins; };

        neovimBuilder = lib.neovimBuilder;
      in
      rec {
        inherit neovimBuilder pkgs;

        apps = {
          nvim = {
            type = "app";
            program = "${defaultPackage}/bin/nvim";
          };
        };

        defaultApp = apps.nvim;

        defaultPackage = packages.neovimWT;


        overlay = (self: super: {
          inherit neovimBuilder;
          neovimWT = packages.neovimWT;
	  neovimPlugins = pkgs.neovimPlugins;
        });

        packages.neovimWT = neovimBuilder {
          config = {
	          vim.viAlias = true;
	          vim.vimAlias = true;
            vim.dashboard.startify.enable = true;
            vim.dashboard.startify.customHeader = [ "NIXOS NEOVIM CONFIG" ];
            vim.theme.nord.enable = true;
            vim.disableArrows = true;
            vim.statusline.lightline.enable = true;
            vim.lsp.enable = true;
            vim.lsp.bash = true;
            vim.lsp.go = true;
            vim.lsp.nix = true;
            vim.lsp.python = true;
            vim.lsp.ruby = true;
            vim.lsp.rust = true;
            vim.lsp.terraform = true;
            vim.lsp.typescript = true;
            vim.lsp.vimscript = true;
            vim.lsp.yaml = true;
            vim.lsp.docker = true;
            vim.lsp.tex = true;
            vim.lsp.css = true;
            vim.lsp.html = true;
            vim.lsp.json = true;
            vim.lsp.clang = true;
            vim.lsp.cmake = false; # Currently broken
            vim.lsp.lightbulb = true;
            vim.lsp.variableDebugPreviews = true;
            vim.fuzzyfind.telescope.enable = true;
            vim.filetree.nvimTreeLua.enable = true;
            vim.git.enable = true;
            vim.tabbar.barbar.enable = true;
            vim.formatting.editorConfig.enable = true;
            vim.editor.indentGuide = true;
            vim.editor.underlineCurrentWord = true;
            vim.database.enable = true;
            vim.test.enable = true;

          };
        };
      });
}
