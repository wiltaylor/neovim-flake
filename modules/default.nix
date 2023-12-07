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
		./git
		./formatting
		./editor
		./test
	];
}
