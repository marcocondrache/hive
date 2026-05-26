# Home Assistant client certificates

This folder issues a private mTLS client CA and a primary client certificate for Cloudflare in front of Home Assistant.

- Upload only `home-assistant-client-ca` / `tls.crt` to Cloudflare as the trusted client CA.
- Install `home-assistant-client-primary` / `tls.crt` and `tls.key` on trusted client devices.
- Keep `home-assistant-client-ca` / `tls.key` private; it can issue new client certificates trusted by Cloudflare.

The initial setup is export-only. `PushSecret` writes the generated CA and client certificate into 1Password. Add `ExternalSecret` imports later if the 1Password items already exist and you want cluster rebuilds to restore the same CA and client certificates instead of minting new ones.

To move to one certificate per device, duplicate `certificate.yaml` and the matching `PushSecret` block with device-specific names, for example:

- `home-assistant-client-marco-iphone`
- `home-assistant-client-marco-macbook`
