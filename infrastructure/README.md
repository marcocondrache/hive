# NixOS Kubernetes Cluster on ARM64 Infrastructure

This Terraform project deploys a Kubernetes cluster on ARM64 infrastructure, consisting of:
- 3 ARM64 VPS instances on Hetzner Cloud
- 3 local Raspberry Pi 4 devices

## Architecture

The infrastructure is deployed in the following steps:
1. Provision ARM64 VPS instances on Hetzner Cloud
2. Configure local Raspberry Pi 4 devices
3. Install NixOS on all nodes using the official nixos-anywhere Terraform module
4. Bootstrap Kubernetes components using Helmfile

## Prerequisites

- [Terraform](https://www.terraform.io/) (v1.0.0 or newer)
- [Nix](https://nixos.org/download.html)
- [Helmfile](https://github.com/helmfile/helmfile)
- SSH access to your Raspberry Pi devices
- Hetzner Cloud API token

## Project Structure

```
infrastructure/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── providers.tf            # Provider configurations
├── terraform.tfvars        # Variable values
├── modules/
│   ├── hetzner/           # Hetzner Cloud VPS module
│   └── raspberry_pi/      # Raspberry Pi module
├── helmfile/
│   └── helmfile.yaml      # Helmfile configuration
└── inventories/           # Generated inventories
```

## Usage

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/nixos-k8s-infrastructure.git
   cd nixos-k8s-infrastructure/infrastructure
   ```

2. Update the `terraform.tfvars` file with your specific values:
   - Hetzner Cloud API token
   - SSH key IDs
   - Raspberry Pi IP addresses
   - NixOS flake URL
   - SSH private key path

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Plan the deployment:
   ```
   terraform plan
   ```

5. Apply the configuration:
   ```
   terraform apply
   ```

6. Access your Kubernetes cluster:
   ```
   export KUBECONFIG=~/.kube/config
   kubectl get nodes
   ```

## NixOS Configuration

This project expects a NixOS flake with configurations for both Hetzner Cloud VPS instances and Raspberry Pi 4 devices. The flake should include the k3s service configuration. Example structure:

```nix
{
  nixosConfigurations = {
    "arm64-vps-1" = {
      # ... node-specific configuration ...
      services.k3s = {
        enable = true;
        role = "server"; # For the first node
      };
    };
    "arm64-vps-2" = {
      # ... node-specific configuration ...
      services.k3s = {
        enable = true;
        role = "agent";
        serverAddr = "https://arm64-vps-1:6443";
      };
    };
    # ... similar configuration for other nodes ...
  };
}
```

## Helmfile Configuration

The Kubernetes components are deployed using Helmfile. The configuration is in `helmfile/helmfile.yaml`. By default, it installs:
- Kubernetes Dashboard
- Metrics Server

To add more applications:
1. Add the repository to the `repositories` section
2. Add a new release under the `releases` section
3. Run `helmfile apply`

## Customization

- To add more nodes, update the `instance_count` and `pi_count` variables
- To modify the Kubernetes components, update the `helmfile.yaml` configuration
- To modify the NixOS configuration, update your NixOS flake

## Cleanup

To destroy the infrastructure:

```
terraform destroy
```

## License

MIT 