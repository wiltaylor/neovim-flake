with builtins;
rec {
	defaultSystems = [
		"aarch64-linux" "aarch64-darwin"
		"x86_64-darwin" "x86_64-linux"
		"i686-linux"
	];

	mkPkgs = { nixpkgs, systems ? defaultSystems, cfg ? {}, overlays ? [] }: withSystems systems (sys: 
		import nixpkgs { 
			system		= sys; 
			config		= cfg; 
			overlays	= overlays; 
		}
	);

	withDefaultSystems = withSystems defaultSystems;

	withSystems = systems: f: foldl' (cur: nxt:
		let
			ret = {
				"${nxt}" = f nxt;
			};
		in cur // ret) {} systems;

	neovimBuilder = {pkgs, config, ...}:
		let
			neovimPlugins	= pkgs.neovimPlugins;

			vimOptions = pkgs.lib.evalModules {
				modules = [
					{ imports = [ ../modules ]; }
					config
				];

				specialArgs = {
					inherit pkgs;
				};
			};

			vim = vimOptions.config.vim;
		in
			pkgs.wrapNeovim config.vim.neovimPackage {
				viAlias		= true;
				vimAlias	= true;

				configure = {
					customRC	= vim.configRC;

					packages.myVimPackage = with pkgs.vimPlugins; {
						start	= vim.startPlugins;
						opt		= vim.optPlugins;
					};
				};
			};
}

