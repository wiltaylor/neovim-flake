{
	description = "A flake to build https://github.com/harrisoncramer/gitlab.nvim";

	inputs = {
		nixpkgs.url		= "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url	= "github:numtide/flake-utils";

		gomod2nix = {
			url = "github:tweag/gomod2nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		gitlab-nvim = {
			url = "github:harrisoncramer/gitlab.nvim";
			flake = false;
		};
	};

	outputs = { self, nixpkgs, ... }@inputs:
	inputs.flake-utils.lib.eachDefaultSystem (system:
	let
		pkgs = import nixpkgs {
			inherit system;

			overlays = [
				inputs.gomod2nix.overlays.default
			];
		};

		server = pkgs.buildGoApplication {
			pname		= "gitlab-nvim-server";
			version		= "2023-12-07";
			src			= inputs.gitlab-nvim;
			modules		= ./gomod2nix.toml;

			buildInputs	= with pkgs; [
				go
			];
		};

		plugin = pkgs.vimUtils.buildVimPlugin {
			pname			= "gitlab-nvim-plugin";
			version			= "2023-12-07";
			src				= inputs.gitlab-nvim;
		};

		package = pkgs.stdenv.mkDerivation {
			name		= "gitlab-nvim";
			src			= inputs.gitlab-nvim;
			installPhase = ''
				mkdir -p $out

				# The plugin looks for a server named 'bin'
				cp ${server}/bin/cmd $out/bin

				# Copy the actual plugin lua
				cp -r ${plugin}/* $out/
			'';
		};
	in {
		packages.gitlab-nvim	= package;
		packages.default		= package;
	}) // {
		overlay = final: prev: {
			neovimPlugins = (prev.neovimPlugins or {}) // {
				gitlab = self.packages.${prev.system}.default;
			};
		};

	};
}
