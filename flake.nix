#https://ziap.github.io/blog/nixos-cross-compilation/
{
  description = "Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {

      devShells.${system}.default =
        let
          targetName = {
            mingw = "x86_64-w64-mingw32";
            musl = "x86_64-unknown-linux-musl";
          };

          # Generate the cross compilation packages import
          pkgsCross = builtins.mapAttrs (
            name: value:
            import pkgs.path {
              system = system;
              crossSystem = {
                config = value;
              };
            }
          ) targetName;

          # Grab the corresponding C compiler binaries
          ccPkgs = builtins.mapAttrs (name: value: value.stdenv.cc) pkgsCross;
          cc = builtins.mapAttrs (name: value: "${value}/bin/${targetName.${name}}-cc") ccPkgs;
        in
        pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              act
              clang-tools
              cmake-format
              cmake
              codespell
              cppcheck
              doxygen
              heaptrack
              emscripten
              gdb
              just
              ninja
              prettier
              prek
              python313
              python313Packages.lizard
              rip2
              ruff
              tombi
              uncrustify
              uv
              wget
              zip
              zlib
              janet
              wine64
              winetricks
              tinyxxd
              jsonschema-cli
              valgrind
              toml2json
              rumdl
            ]
            ++ builtins.attrValues ccPkgs;

          CCFLAGS = builtins.map (a: "-L ${a}/lib") [
            pkgsCross.mingw.windows.pthreads
          ];

          shellHook = ''
            prek install -f
            export EM_CACHE="$PWD/.emcache"
            export WINEPREFIX=$(pwd)/.wine/
            just bootstrap
            source .venv/bin/activate
            echo done!
          '';
        };
    };
}
