{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.editor;
in {
  options.vim.editor = {
    indentGuide = mkEnableOption "Enable indent guides";
    underlineCurrentWord = mkEnableOption "Underline the word under the cursor";

   
    colourPreview = mkOption {
      description = "Enable colour previews";
      type = types.bool;
      default = true;
    };

    whichKey = mkOption {
      description = "Enable Which key";
      type = types.bool;
      default = true;
    };

    floaterm = mkOption {
      description = "Enable floaterm instead of built in";
      type = types.bool;
      default = true;
    };
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [ 
      (if cfg.indentGuide then indent-blankline-nvim else null)
      (if cfg.indentGuide then indentline else null)
      (if cfg.underlineCurrentWord then vim-cursorword else null)
      # Currently broken. Need to add a build step
      # Need to run make hexokinase in the plugin folder
      #(if cfg.colourPreview then vim-hexokinase else null)

      (if cfg.whichKey then nvim-which-key else null)
      #(if cfg.floaterm then vim-floaterm else null)
    ];

    vim.nnoremap = {
     # "<leader>`" = "<cmd>FloatermNew<cr>";
    #  "<leader>`j" = "<cmd>FloatermNext<cr>";
     # "<leader>`k" = "<cmd>FloatermPrev><cr>";
     "<leader>wc" = "<cmd>close<cr>";
     "<leader>wh" = "<cmd>split<cr>";
     "<leader>wv" = "<cmd>vsplit<cr>";
    };

    vim.luaConfigRC = ''
      local wk = require("which-key")

      wk.register({
        w = {
          name = "window",
          c = { "Close Window"},
          h = { "Split Horizontal" },
          v = { "Split Vertical" },
        },
      }, { prefix = "<leader>" })
     
    '';

    vim.configRC = ''
      ${if cfg.indentGuide then ''
        let g:indentLine_enabled = 1
        set list lcs=tab:\|\ 
      '' else ""}
      "let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla'"
    '';

  };
}
