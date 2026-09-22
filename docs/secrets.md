# Secrets with SOPS and age

Commit only SOPS-encrypted files and public recipients. Never put plaintext tokens
or private keys in Nix expressions, source files, or the Nix store. A gitignore
entry alone does not prevent Nix from copying secrets into the store.

The first integration is `services.github-runners.bunte-app` on `thekorn-server`.
Its encrypted file is `secrets/thekorn-server/github-runner-bunte-app`, in SOPS
binary format (a JSON envelope containing encrypted raw bytes). At activation,
sops-nix decrypts it to `/run/secrets/github-runner-bunte-app`, owned by root with
mode `0400`. The NixOS runner module reads the token using its privileged startup
helper. Secret changes request a runner restart on activation.

Until the encrypted file is added, evaluation warns and retains the existing
`/var/lib/github-runner-secrets/bunte-app.token` path. No placeholder token is used.

## Create the encrypted runner token

Use a fine-grained GitHub PAT scoped to `thekorn/bunte-app` with repository
Administration read/write permission for runner registration. Set an expiration
and rotate before it expires. A runner registration token also works, but expires
after one hour and is unsuitable for future unattended re-registration.
Changing the configured token path can trigger re-registration, so use a valid
token even if the runner is already registered.

From the repository root, enter a shell with tools from the pinned nixpkgs:

```sh
nix shell --inputs-from . nixpkgs#sops nixpkgs#age -c bash
```

Run the following inside that Bash shell. The token is read without echoing or
putting it in shell history, process arguments, or a plaintext file. Do not enable
shell tracing (`set -x`). Only ciphertext is written to disk.

```bash
mkdir -p secrets/thekorn-server
(
  set -euo pipefail
  file=secrets/thekorn-server/github-runner-bunte-app
  tmp=$(mktemp)
  trap 'rm -f "$tmp"' EXIT
  IFS= read -r -s -p 'GitHub runner PAT: ' token
  printf '\n' >&2
  test -n "$token"
  printf '%s' "$token" | sops encrypt \
    --filename-override "$file" \
    --input-type binary --output-type json /dev/stdin > "$tmp"
  unset token
  mv "$tmp" "$file"
)
sops filestatus secrets/thekorn-server/github-runner-bunte-app
git add .sops.yaml secrets/thekorn-server/github-runner-bunte-app
```

The final status must report `"encrypted": true`. Git-backed flakes only include
tracked files; staging the ciphertext makes it visible to evaluation. Review the
file before committing: it must contain SOPS metadata and encrypted data, never
the token. Repeat the encryption steps to replace/rotate the token; encryption
only requires the public recipient, so it works from a Mac without the host key.

## Validate and deploy

```sh
nix eval --raw .#nixosConfigurations.thekorn-server.config.services.github-runners.bunte-app.tokenFile
# Expected: /run/secrets/github-runner-bunte-app
```

When ready to deploy (this switches the server configuration and can restart the
runner), use the existing deployment command:

```sh
nix run .#deploy-thekorn-server
ssh -t thekorn@thekorn-server.home \
  'sudo stat -c "%U:%G %a" /run/secrets/github-runner-bunte-app; systemctl status github-runner-bunte-app --no-pager'
```

Check that ownership/mode is `root:root 400` and that the runner is online in
GitHub. Do not print the decrypted token in logs. After successful migration,
remove the old manually provisioned token file on the server and remove the
bootstrap fallback from the host configuration.

## Keys and recovery

`.sops.yaml` currently encrypts only to the server's existing SSH Ed25519 host
identity. sops-nix converts `/etc/ssh/ssh_host_ed25519_key` for age decryption;
the private key is not copied to the repo or fetched to the Mac. Its public age
recipient was derived from the host public key via `ssh-to-age`.

Back up that host private key securely, or add a separate administrator/recovery
age recipient before relying on this for irreplaceable secrets. Losing the host
key means losing decryption access; for this token, recovery is to issue a new PAT
and encrypt it to the replacement host's public key. The current setup does not
allow local decryption/editing on your Mac.

To add a recovery identity, generate it outside the repo using `age-keygen`, back
it up securely, and add only its public recipient to the rule's `age` list. Then
re-encrypt the token using the steps above (or run `sops updatekeys` where an
existing decryption identity is available). Editing `.sops.yaml` alone does not
update existing ciphertext. Each listed recipient can decrypt the entire file.

Use separate rules/recipients for other hosts; do not grant work machines access
to personal server secrets by default. Removing a recipient does not revoke old
ciphertext in Git history: rotate the actual token after a key compromise.
