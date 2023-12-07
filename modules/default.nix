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
		./formatting
		./editor
		./test
	];
}
