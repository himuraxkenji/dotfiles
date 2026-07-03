{ pkgs, ... }:

let
  zjstatus = pkgs.fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.23.0/zjstatus.wasm";
    sha256 = "1zv173qh67x4bf4k4m5fpz22vy0pbp6f88c0c7dkjhjj4c9901p0";
  };

  zellijForgot = pkgs.fetchurl {
    url = "https://github.com/karimould/zellij-forgot/releases/download/0.4.2/zellij_forgot.wasm";
    sha256 = "1ns9wjn1ncjapqpp9nn9kyhqydvl0fbnyiavd0lc3gcxa52l269i";
  };
in
{
  xdg.configFile = {
    "zellij/plugins/zjstatus.wasm".source = zjstatus;
    "zellij/plugins/zellij_forgot.wasm".source = zellijForgot;
    "zellij/config.kdl".source = ./zellij/config.kdl;
    "zellij/layouts/default.kdl".source = ./zellij/layouts/default.kdl;
  };
}
