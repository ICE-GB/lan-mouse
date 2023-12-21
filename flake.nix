{
  description = "Nix Flake for lan-mouse";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    ...
  }: let
    inherit (nixpkgs) lib;
    genSystems = lib.genAttrs [
      "x86_64-linux"
    ];
    pkgsFor = system:
      import nixpkgs {
        inherit system;

        overlays = [
          rust-overlay.overlays.default
        ];
      };
    mkRustToolchain = pkgs:
      pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src"];
      };
  in {
    devShells = genSystems (system: let
      pkgs = pkgsFor system;
      rust = mkRustToolchain pkgs;
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          rust
          rust-analyzer-unwrapped
          gcc
          gtk3
          gtk4
          libadwaita
          xorg.libXtst
          gtk-layer-shell
          pkg-config
          openssl
          gdk-pixbuf
          glib
          glib-networking
          shared-mime-info
          gnome.adwaita-icon-theme
          hicolor-icon-theme
          gsettings-desktop-schemas
          libxkbcommon
        ];

        RUST_SRC_PATH = "${rust}/lib/rustlib/src/rust/library";
      };
    });
  };
}