{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.lsp;
in {

  options.vim.lsp = {
    enable = mkEnableOption "Enable lsp support";

    bash = mkEnableOption "Enable Bash Language Support";
    go = mkEnableOption "Enable Go Language Support";
    nix = mkEnableOption "Enable NIX Language Support";

  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ 
      nvim-lspconfig 
      completion-nvim 
      nvim-dap
      (if cfg.nix then vim-nix else null)
    ];

    vim.configRC = ''
      " Use <Tab> and <S-Tab> to navigate through popup menu
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

      " Set completeopt to have a better completion experience
      set completeopt=menuone,noinsert,noselect
    '';

    vim.nnoremap = {
      "<f2>" = "<cmd>lua vim.lsp.buf.rename()<cr>";
      "<leader>r" = "<cmd>lua vim.lsp.buf.rename()<cr>";
      "<leader>d" = "<cmd>lua vim.lsp.buf.type_definition()<cr>";
      "<leader>e" = "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>";
      "<leader>f" = "<cmd>lua vim.lsp.buf.formatting()<CR>";
      "<leader>k" = "<cmd>lua vim.lsp.buf.signature_help()<CR>";

      gD = "<cmd>lua vim.lsp.buf.declaration()<CR>";
      gd = "<cmd>lua vim.lsp.buf.definition()<CR>";
      gi = "<cmd>lua vim.lsp.buf.implementation()<CR>";
      gr = "<cmd>lua vim.lsp.buf.references()<CR>";
      K = "<cmd>lua vim.lsp.buf.hover()<CR>";

      "[d" = "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>";
      "]d" = "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>";

      "<leader>q" = "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>";

      # dap
      "<F10>" = "lua require'dap'.step_over()<cr>";
      "<F11>" = "lua require'dap'.step_into()<cr>";
      "<F12>" = "lua require'dap'.step_out()<cr>";
      "<F5>" = "lua require'dap'.continue()<cr>";
      "<leader>b" = "lua require'dap'.toggle_breakpoint()<cr>";
    };

    vim.globals = {
    };

    vim.luaConfigRC = ''
      local lspconfig = require'lspconfig'
      local dap = require "dap"

      ${if cfg.bash then ''
        lspconfig.bashls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start"}
        }
      '' else ""}

      ${if cfg.go then ''
        lspconfig.gopls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {"${pkgs.gopls}/bin/gopls"}
        }

        dap.adapters.go = function(callback, config)
          local handle
          local pid_or_err
          local port = 38697
          handle, pid_or_err =
            vim.loop.spawn(
            "dlv",
            {
              args = {"dap", "-l", "127.0.0.1:" .. port},
              detached = true
            },
        function(code)
          handle:close()
          print("Delve exited with exit code: " .. code)
        end
          )
          -- Wait 100ms for delve to start
          vim.defer_fn(
            function()
              --dap.repl.open()
              callback({type = "server", host = "127.0.0.1", port = port})
            end,
            100)


          --callback({type = "server", host = "127.0.0.1", port = port})
        end
        -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
        dap.configurations.go = {
          {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${pkgs.delve}/bin/delve"
          }
        }
      '' else ""}

      ${if cfg.nix then ''
        lspconfig.rnix.setup{
          on_attach=require'completion'.on_attach;
          cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
        }
      '' else ""}
    '';
  };
}
