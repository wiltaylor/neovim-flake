{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.editor;
in {
  options.vim.editor = {
    colorPreview = mkOption {
      description = "Enable color previews";
      type = types.bool;
      default = true;
    };

  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [ 
      (if cfg.colorPreview then vim-css-color else null)
      vim-tmux-navigator
      nvim-which-key
    ];

    vim.nnoremap = {
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

  };
}
