let
  commit = "9ef6e7727f4c31507627815d4f8679c5841efb00";
  link =  "https://github.com/NixOS/nixpkgs/archive/${commit}.zip";
  tarball = fetchTarball link;
in                                                                                                                                             
{ pkgs ? import tarball {} }:

pkgs.mkShell rec {
  name = "latex-shell";

  buildInputs = with pkgs; [
    less
    # texlive.combined.scheme-small
    (texlive.combine {
      inherit (texlive)
        scheme-small
        # collection-langcjk
        # collection-xetex
        xecjk
        ctex
      ;
    })
    # kochi-substitute # MS Mincho and MS Gothic fonts
    zathura
  ];

  shellHook = ''
    export PS1="\n\[\033[1;32m\][${name}: \w]\n\$\[\033[0m\] "
    export PURE="$([[ $IN_NIX_SHELL -eq 'pure' ]] && echo 1 || echo 0)"
    echo '>> Welcome to ${name}! <<'
    echo "PURE=$PURE"
    build () { xelatex $*; }
    build2 () { build $* && build $*; }
    view () { zathura $* 2>/dev/null & }
  '';
}
