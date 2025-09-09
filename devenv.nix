{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  pwd = config.env.DEVENV_ROOT;
in
{
  name = "hive";

  dotenv.enable = true;

  env = {
    "HELM_PLUGINS" = config.env.DEVENV_PROFILE;
    "KUBECONFIG" = "${pwd}/kubeconfig";
    "TALOSCONFIG" = "${pwd}/kubernetes/talos/clusterconfig/talosconfig";
    "ROOT_DIR" = "${pwd}";
  };

  git-hooks.hooks = {
    yamlfmt = {
      enable = true;
      settings.configPath = "${pwd}/.yamlfmt.yaml";
    };
  };

  packages = [
    pkgs.go-task
    pkgs.helmfile
    pkgs.yamlfmt
    pkgs._1password-cli
    pkgs.kubectl
    pkgs.fluxcd
    pkgs.kubernetes-helm
    pkgs.kubernetes-helmPlugins.helm-diff
    pkgs.cilium-cli
    pkgs.minijinja
    pkgs.talhelper
    pkgs.kubefetch
    pkgs.talosctl
    pkgs.yq-go
    pkgs.hey
    pkgs.kubectl-node-shell

    inputs.talhelper.packages.${pkgs.system}.default
  ];
}
