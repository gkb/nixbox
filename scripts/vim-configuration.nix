{ pkgs, ... }:
{
  environment.variables = { EDITOR = "vim"; };

  environment.systemPackages = with pkgs; [
    ((vim_configurable.override {  }).customize{
      name = "vim";
      # Install plugins for example for syntax highlighting of nix files
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          vim-airline
          vim-nix
          vim-lastplace
          YouCompleteMe
        ];
        opt = [];
      };
      vimrcConfig.customRC = ''
        " my custom vimrc
        set nocompatible
        set backspace=indent,eol,start
        set autoindent
        set expandtab
        set tabstop=2
        set shiftwidth=2
        " Turn on syntax highlighting by default
        syntax on
        " Get the powerline fonts for vim-airline.
        let g:airline_powerline_fonts = 1
        " ...
      '';
    }
  )];
}
