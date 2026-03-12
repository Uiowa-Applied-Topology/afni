#https://ziap.github.io/blog/nixos-cross-compilation/
{
  description = "Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixgl,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
      };

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
              libx11
              libxmu
              motif
              libjpeg-tools
              libjpeg
              libGLU
              gsl
              glib
              expat
              libX11
              libXcursor
              libxcb
              libXi
              libXpm
              zlib
              libgbm
              libGL
              freeglut
            ]
            ++ builtins.attrValues ccPkgs;

          NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            # For sure not all of these are needed for clion.
            # I don't want to figure out which ones are.
            pkgs.alsa-lib
            pkgs.at-spi2-atk
            pkgs.at-spi2-core
            pkgs.atk
            pkgs.bzip2
            pkgs.cairo
            pkgs.cups
            pkgs.curl
            pkgs.curlWithGnuTls
            pkgs.dbus
            pkgs.dbus-glib
            pkgs.desktop-file-utils
            pkgs.e2fsprogs
            pkgs.expat
            pkgs.flac
            pkgs.fontconfig
            pkgs.freeglut
            pkgs.freetype
            pkgs.fribidi
            pkgs.fuse
            pkgs.fuse3
            pkgs.gdk-pixbuf
            pkgs.glew110
            pkgs.glib
            pkgs.gmp
            pkgs.gst_all_1.gst-plugins-ugly
            pkgs.gst_all_1.gstreamer
            pkgs.gtk2
            pkgs.harfbuzz
            pkgs.icu
            pkgs.keyutils.lib
            pkgs.libappindicator-gtk2
            pkgs.libcaca
            pkgs.libcanberra
            pkgs.libcap
            pkgs.libclang.lib
            pkgs.libdbusmenu
            pkgs.libdrm
            pkgs.libgcrypt
            pkgs.libGL
            pkgs.libGLU
            pkgs.libgpg-error
            pkgs.libidn
            pkgs.libjack2
            pkgs.libjpeg
            pkgs.libmikmod
            pkgs.libogg
            pkgs.libpng12
            pkgs.libpulseaudio
            pkgs.librsvg
            pkgs.libsamplerate
            pkgs.libthai
            pkgs.libtheora
            pkgs.libtiff
            pkgs.libudev0-shim
            pkgs.libusb1
            pkgs.libuuid
            pkgs.libvdpau
            pkgs.libvorbis
            pkgs.libvpx
            pkgs.libxcrypt-legacy
            pkgs.libxkbcommon
            pkgs.libxml2
            pkgs.libzip
            pkgs.mesa
            pkgs.nspr
            pkgs.nss
            pkgs.openssl
            pkgs.p11-kit
            pkgs.pango
            pkgs.pixman
            pkgs.python3
            pkgs.SDL
            pkgs.SDL_image
            pkgs.SDL_mixer
            pkgs.SDL2
            pkgs.SDL2_image
            pkgs.SDL2_mixer
            pkgs.SDL2_ttf
            pkgs.speex
            pkgs.tbb
            pkgs.udev
            pkgs.vulkan-loader
            pkgs.wayland
            pkgs.libICE
            pkgs.libpciaccess
            pkgs.libSM
            pkgs.libX11
            pkgs.libxcb
            pkgs.libXcomposite
            pkgs.libXcursor
            pkgs.libXdamage
            pkgs.libXext
            pkgs.libXfixes
            pkgs.libXft
            pkgs.libXi
            pkgs.libXinerama
            pkgs.libXmu
            pkgs.libXrandr
            pkgs.libXrender
            pkgs.libXScrnSaver
            pkgs.libXt
            pkgs.libXtst
            pkgs.libXxf86vm
            pkgs.stdenv.cc.cc
            pkgs.stdenv.cc.cc.lib
            pkgs.xcbutil
            pkgs.xcbutilimage
            pkgs.xcbutilkeysyms
            pkgs.xcbutilrenderutil
            pkgs.xcbutilwm
            pkgs.xkeyboardconfig
            pkgs.xz
            pkgs.zlib
            pkgs.freeglut
          ];

          CCFLAGS = builtins.map (a: "-L ${a}/lib") [
            pkgsCross.mingw.windows.pthreads
          ];

          shellHook = ''
            export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
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
