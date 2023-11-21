let
    rust_overlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
    pkgs = import <nixpkgs> { overlays = [ rust_overlay ]; };
    rust_version = "1.61.0";
    rust = pkgs.rust-bin.stable.${rust_version}.default.override {
        targets = [ "x86_64-unknown-linux-musl" ];
    };
    tex = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-medium titlesec;
    };
    cross = import <nixpkgs> {
        crossSystem = { config = "aarch64-none-elf"; };
    };
    python = pkgs.python310Packages;
in
  pkgs.mkShell {
    buildInputs = with pkgs.buildPackages; [
        gnumake
        dtc
        expect
        python39
        git
        gcc
        rust
        # gmp.out
        pandoc
        tex
        cmake
        cross.buildPackages.gcc10
        ninja
        libxml2
        # not available
        # python.pyoxidizer
        python.mypy
        python.black
        python.flake8
        python.ply
        python.jinja2
        python.pyaml
        python.libfdt
    ];
    shellHook = ''
        export PYOXIDIZER_SYSTEM_RUST=1
    '';
}
