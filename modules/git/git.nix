{ pkgs, config, lib, inputs, ...}:
with lib;
with builtins;

let
    cfg = config.vim.git;
in {
    options.vim.git = {
        enable          =  mkEnableOption "Git support"; 
        blameLine = mkOption {
            default     = true;
            description = "Prints blame info of who edited the line you are on.";
            type        = types.bool;
        };
    };

    config = mkIf cfg.enable {
        vim.startPlugins = with pkgs.neovimPlugins; [
            fugitive
            fugitive-gitlab
            nvim-telescope
            gitsigns
            plenary-nvim
            neogit

            gitlab
            nui-nvim
            dressing-nvim
            diffview-nvim
        ] ++ lib.optionals cfg.blameLine [
            nvim-blame-line
        ];

        vim.luaConfigRC = ''
            ${builtins.readFile ./git.lua}

            -- Hack to make sure we have go installed
            -- ${pkgs.go}
            '';

        vim.configRC = ''
            ${if cfg.blameLine then "autocmd BufEnter * EnableBlameLine" else ""}
        '';
    };
}

