# lowkeylab-nix

This repository publishes shared CLI tools as Nix packages for Lowkey Lab repositories.

## Public contract

- Linux only: `x86_64-linux`
- Packages only: no shared devShells
- First package: `packages.x86_64-linux.aspect`

## Consuming `aspect`

In another flake, add this repository as an input and reference:

`inputs.lowkeylab-nix.packages.x86_64-linux.aspect`

Consumer repositories should compose their own dev shells or CI environments from these packages.

## Repository automation

- CI runs in GitHub Actions on pull requests, pushes to `main`, and manual dispatches.
- The workflow validates the flake with `nix flake check` and builds `.#packages.x86_64-linux.aspect` on Linux.
- Renovate is configured for Nix and weekly `flake.lock` maintenance via `renovate.json`.
- To activate Renovate updates, install the Mend Renovate GitHub App or point a self-hosted Renovate runner at this repository.
