{ system ? builtins.currentSystem }:
import (import ./source.nix) {
  inherit system;
  config = {};
  overlays = [];
}
