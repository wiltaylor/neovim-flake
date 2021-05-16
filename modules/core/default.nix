{ config, lib, pkgs, ...}:

with lib;
with builtins;
let
  cfg = config.vim;

  wrapLuaConfig = luaConfig: ''
    lua << EOF
    ${luaConfig}
    EOF
  '';

in {
  options.vim = {
    configRC = mkOption {
      description = ''vimrc contents'';
      type = types.lines;
      default = "";
    };

    luaConfigRC = mkOption {
      description = ''vim lua config'';
      type = types.lines;
      default = "";
    };

    startPlugins = mkOption {
      description = "List of plugins to startup";
      default = [ ];
      type = with types; listOf package;
    };

    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      default = [ ];
      type =  with types; listOf package;
    };

    globals = mkOption {
      default = {};
      description = "Set containing global variable values";
      type = types.attrs;
    };

  };

  config = let
    filterNonNull = mappings: filterAttrs (name: value: value != null) mappings;
    globalsScript = mapAttrsFlatten(name: value: "let g:${name}=${toJSON value}") (filterNonNull cfg.globals);
  in {
    vim.configRC = ''
      " Lua config from vim.luaConfigRC
      ${wrapLuaConfig cfg.luaConfigRC}
      ${concatStringsSep "\n" globalsScript}
    '';
  };

}
