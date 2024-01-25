# Nix Flake Usage

## run

```bash
nix run github:ICE-GB/lan-mouse/nix-module

# with params
nix run github:ICE-GB/lan-mouse/nix-module -- --help

```

## home-manager module

add input

```nix
inputs = {
    lan-mouse.url = "github:ICE-GB/lan-mouse/nix-module";
}
```

enable lan-mouse

``` nix
{
  inputs,
  ...
}: {
  # add the home manager module
  imports = [inputs.lan-mouse.homeManagerModules.default];

  programs.lan-mouse = {
    enable = true;
  };
}

```
