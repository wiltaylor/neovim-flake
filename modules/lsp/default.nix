{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.lsp;

  debugpy = pkgs.python3.withPackages (pyPkg: with pyPkg; [ debugpy ]);
in {

  options.vim.lsp = {
    enable = mkEnableOption "Enable lsp support";

    bash = mkEnableOption "Enable Bash Language Support";
    go = mkEnableOption "Enable Go Language Support";
    nix = mkEnableOption "Enable NIX Language Support";
    python = mkEnableOption "Enable Python Support";
    ruby = mkEnableOption "Enable Ruby Support";
    rust = mkEnableOption "Enable Rust Support";
    terraform = mkEnableOption "Enable Terraform Support";
    typescript = mkEnableOption "Enable Typescript/Javascript Support";
    vimscript = mkEnableOption "Enable Vim Script Support";
    yaml = mkEnableOption "Enable yaml support";
    docker = mkEnableOption "Enable docker support";
    tex = mkEnableOption "Enable tex support";
    css = mkEnableOption "Enable css support";
    html = mkEnableOption "Enable html support";
    clang = mkEnableOption "Enable C/C++ with clang";
    cmake = mkEnableOption "Enable CMake";
    json = mkEnableOption "Enable JSON";

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

      "<f10>" = "<cmd>lua require'dap'.step_over()<cr>";
      "<f11>" = "<cmd>lua require'dap'.step_into()<cr>";
      "<f12>" = "<cmd>lua require'dap'.step_out()<cr>";
      "<f5>" = "<cmd>lua require'dap'.continue()<cr>";
      "<leader>b" = "<cmd>lua require'dap'.toggle_breakpoint()<cr>";
    };

    vim.globals = {
    };

    vim.luaConfigRC = ''
      local lspconfig = require'lspconfig'
      local dap = require'dap'

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
            "${pkgs.delve}/bin/dlv",
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
            program = "${"$"}{file}" 
          }
        }
      '' else ""}

      ${if cfg.nix then ''
        lspconfig.rnix.setup{
          on_attach=require'completion'.on_attach;
          cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
        }
      '' else ""}

      ${if cfg.ruby then ''
        lspconfig.solargraph.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.solargraph}/bin/solargraph', 'stdio'}
        }
      '' else ""}

      ${if cfg.rust then ''
        lspconfig.rust_analyzer.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.rust-analyzer}/bin/rust-analyzer'}
        }
      '' else ""}

      ${if cfg.terraform then ''
        lspconfig.terraformls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.terraform-ls}/bin/terraform-ls', 'serve' }
        }
      '' else ""}

      ${if cfg.typescript then ''
        lspconfig.tsserver.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.vimscript then ''
        lspconfig.vimls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.vim-language-server}/bin/vim-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.yaml then ''
        lspconfig.vimls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.docker then ''
        lspconfig.dockerls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.dockerfile-language-server-nodejs}/bin/docker-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.css then ''
        lspconfig.cssls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver', '--stdio' };
          filetypes = { "css", "scss", "less" }; 
        }
      '' else ""}

      ${if cfg.html then ''
        lspconfig.html.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver', '--stdio' };
          filetypes = { "html", "css", "javascript" }; 
        }
      '' else ""}

      ${if cfg.json then ''
        lspconfig.jsonls.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.nodePackages.vscode-json-languageserver-bin}/bin/json-languageserver', '--stdio' };
          filetypes = { "html", "css", "javascript" }; 
        }
      '' else ""}

      ${if cfg.tex then ''
        lspconfig.texlab.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.texlab}/bin/texlab'}
        }
      '' else ""}

      ${if cfg.clang then ''
        lspconfig.clangd.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.llvmPackages_latest.clang}/bin/clangd', '--background-index'};
          filetypes = { "c", "cpp", "objc", "objcpp" };
        }
      '' else ""}

      ${if cfg.cmake then ''
        lspconfig.cmake.setup{
          on_attach=require'completion'.on_attach;
          cmd = {'${pkgs.cmake-language-server}/bin/cmake-language-server'};
          filetypes = { "cmake"};
        }
      '' else ""}

      ${if cfg.python then ''
        lspconfig.pyright.setup{
          on_attach=require'completion'.on_attach;
          cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
        }

        dap.adapters.python = {
          type = 'executable';
          command = '${debugpy}/bin/python';
          args = { '-m', 'debugger.adapter' };
        }

        dap.configurations.python = {
          {
            -- The first three options are required by nvim-dap
            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch';
            name = "Launch file";

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${"$"}{file}"; -- This configuration will launch the current file if used.
            pythonPath = function()
              -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
              -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
              -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
              local cwd = vim.fn.getcwd()
              if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                return cwd .. '/venv/bin/python'
              elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                return cwd .. '/.venv/bin/python'
              else
                return '${debugpy}/bin/python'
              end
            end;
          },
        }
      '' else ""}

    '';
  };
}
