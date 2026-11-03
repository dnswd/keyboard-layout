{
  description = "QMK Firmware Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "qmk-dev-shell";

          packages = with pkgs; [
            qmk
            # ARM compiler (for RP2040, STM32, etc.)
            gcc-arm-embedded
            # AVR compiler
            pkgsCross.avr.buildPackages.gcc
            # Flashing & debugging tools
            avrdude
            dfu-programmer
            dfu-util
            dos2unix
            teensy-loader-cli
            # python environment with tools for QMK
            (python3.withPackages (
              ps: with ps; [
                pyserial
                milc
                argcomplete
                colorama
                jinja2
                pyusb
                hjson
                jsonschema
                dotmap
                pyyaml
              ]
            ))
            git
          ];

          shellHook = ''
            echo "=========================================================="
            echo "   QMK Firmware Development Environment (Nix Flake)"
            echo "=========================================================="
            echo "Available tools:"
            echo "  - qmk (CLI)"
            echo "  - arm-none-eabi-gcc (ARM compiler)"
            echo "  - avr-gcc (AVR compiler)"
            echo "  - dfu-util, dfu-programmer, avrdude (flashing tools)"
            echo ""
            echo "To get started, set up QMK firmware if you haven't already:"
            echo "  qmk setup"
            echo "=========================================================="
          '';
        };
      }
    );
}
