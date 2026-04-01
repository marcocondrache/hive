{
  pkgs,
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
    "MINIJINJA_CONFIG_FILE" = "${pwd}/.minijinja.toml";
    "KUBECONFIG" = "${pwd}/kubeconfig";
    "TALOSCONFIG" = "${pwd}/talosconfig";
    "JUST_UNSTABLE" = "1";
    "ROOT_DIR" = "${pwd}";
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
    pkgs.just
    pkgs.gum
    pkgs.kustomize
    pkgs.kubectl-node-shell

    inputs.talhelper.packages.${pkgs.system}.default
  ];
}
