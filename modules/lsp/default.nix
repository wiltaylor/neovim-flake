{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
    cfg = config.vim.lsp;
in {
    options.vim.lsp = {
        enable      = mkEnableOption "LSP support";

        bash        = mkEnableOption "Bash Language Support";
        go          = mkEnableOption "Go Language Support";
        nix         = mkEnableOption "NIX Language Support";
        python      = mkEnableOption "Python Support";
        ruby        = mkEnableOption "Ruby Support";
        rust        = mkEnableOption "Rust Support";
        terraform   = mkEnableOption "Terraform Support";
        typescript  = mkEnableOption "Typescript/Javascript Support";
        vimscript   = mkEnableOption "Vim Script Support";
        yaml        = mkEnableOption "yaml support";
        docker      = mkEnableOption "docker support";
        tex         = mkEnableOption "tex support";
        css         = mkEnableOption "css support";
        html        = mkEnableOption "html support";
        clang       = mkEnableOption "C/C++ with clang";
        json        = mkEnableOption "JSON";
        graphql     = mkEnableOption "GraphQL";

        lightbulb   = mkEnableOption "Light Bulb";
        variableDebugPreviews = mkEnableOption "Enable variable previews";
    };

    config = mkIf cfg.enable {
        vim.startPlugins = with pkgs.neovimPlugins; [ 
            nvim-lspconfig
            nvim-lsp-smag
            lsp_signature
			null-ls
			gitsigns

            nvim-dap
            nvim-telescope
            nvim-telescope-dap

            pkgs.vimPlugins.nvim-treesitter.withAllGrammars
            nvim-treesitter-context
            nvim-treesitter-textobjects

            (if cfg.nix                     then vim-nix                else null)
            (if cfg.lightbulb               then nvim-lightbulb         else null)
            (if cfg.variableDebugPreviews   then nvim-dap-virtual-text  else null)
        ];

        vim.configRC = ''
            ${if cfg.variableDebugPreviews then "let g:dap_virtual_text = v:true" else ""}
            
            set completeopt=menuone,longest,noselect,preview
            '';

        vim.globals = {
        };

        vim.luaConfigRC = ''
            ${builtins.readFile ./lsp.lua}

            ${if cfg.lightbulb then ''
            require'nvim-lightbulb'.update_lightbulb {
                sign = {
                    enabled                 = true,
                    priority                = 10,
                },
                float = {
                    enabled                 = false,
                    text                    = "💡",
                    win_opts                = {},
                },
                virtual_text = {
                    enable                  = false,
                    text                    = "💡",
                },
                status_text = {
                    enabled                 = false,
                    text                    = "💡",
                    text_unavailable        = ""           
                }
            }
            '' else ""}

            ${if cfg.bash then ''
            lspconfig.bashls.setup {
                cmd = {
                    "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server",
                    "start"
                }
            }
            '' else ""}

            ${if cfg.go then ''
            lspconfig.gopls.setup {
                cmd = {
                    "${pkgs.gopls}/bin/gopls"
                }
            } 

            dap.adapters.go = function(callback, config)
                local handle
                local pid_or_err
                local port = 38697

                handle, pid_or_err = vim.loop.spawn(
                    "dlv",
                    {
                        args        = {"dap", "-l", "127.0.0.1:" .. port},
                        detached    = true
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
                    type        = "go",
                    name        = "Debug",
                    request     = "launch",
                    program     = "${"$"}{workspaceFolder}"
                },
                {
                    type        = "go",
                    name        = "Debug test", -- configuration for debugging test files
                    request     = "launch",
                    mode        = "test",
                    program     = "${"$"}{workspaceFolder}"
                },
            }
            '' else ""}

            ${if cfg.nix then ''
            lspconfig.rnix.setup{
                cmd             = { "${pkgs.rnix-lsp}/bin/rnix-lsp" }
            }
            '' else ""}

            ${if cfg.ruby then ''
            lspconfig.solargraph.setup{
                cmd             = {'${pkgs.solargraph}/bin/solargraph', 'stdio' }
            }
            '' else ""}

            ${if cfg.rust then ''
            lspconfig.rust_analyzer.setup{
                cmd             = {'${pkgs.rust-analyzer}/bin/rust-analyzer'}
            }
            '' else ""}

            ${if cfg.terraform then ''
            lspconfig.terraformls.setup{
                cmd             = {'${pkgs.terraform-ls}/bin/terraform-ls', 'serve' }
            }
            '' else ""}

            ${if cfg.typescript then ''
            lspconfig.tsserver.setup{
                cmd             = {'${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio' }
            }
            '' else ""}

            ${if cfg.vimscript then ''
            lspconfig.vimls.setup{
                cmd             = {'${pkgs.nodePackages.vim-language-server}/bin/vim-language-server', '--stdio' }
            }
            '' else ""}

            ${if cfg.yaml then ''
            lspconfig.vimls.setup{
                cmd             = {'${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server', '--stdio' }
            }
            '' else ""}

            ${if cfg.docker then ''
            lspconfig.dockerls.setup{
                cmd             = {'${pkgs.nodePackages.dockerfile-language-server-nodejs}/bin/docker-language-server', '--stdio' }
            }
            '' else ""}

            ${if cfg.css then ''
            lspconfig.cssls.setup{
                cmd             = {'${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver', '--stdio' };
                filetypes       = { "css", "scss", "less" }; 
            }
            '' else ""}

            ${if cfg.html then ''
            lspconfig.html.setup{
                cmd             = {'${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver', '--stdio' };
                filetypes       = { "html", "css", "javascript" }; 
            }
            '' else ""}

            ${if cfg.json then ''
            lspconfig.jsonls.setup{
                cmd             = {'${pkgs.nodePackages.vscode-json-languageserver-bin}/bin/json-languageserver', '--stdio' };
                filetypes       = { "html", "css", "javascript" }; 
            }
            '' else ""}

            ${if cfg.graphql then ''
            lspconfig.graphql.setup{
                cmd             = {'${nodePackages_latest.graphql-language-service-cli}/bin/graphql-lsp', 'server', '-m', 'stream' };
                filetypes       = { "html", "css", "javascript" }; 
            }
            '' else ""}


            ${if cfg.tex then ''
            lspconfig.texlab.setup{
                cmd             = {'${pkgs.texlab}/bin/texlab'}
            }
            '' else ""}

            ${if cfg.clang then ''
            -- This avoids conflicts with null-ls
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.offsetEncoding = { "utf-16" }

            lspconfig.clangd.setup{
                cmd             = {'${pkgs.clang-tools}/bin/clangd', '--background-index'};
                capabilities    = capabilities,
                filetypes       = { "c", "cpp", "objc", "objcpp", "m" };
            }
            '' else ""}

            ${if cfg.python then ''
            lspconfig.pyright.setup{
                cmd             = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
            }
            '' else ""}
            '';
    };
}
