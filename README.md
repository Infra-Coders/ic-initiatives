# GitHub Label Sync (Infra-Coders)

Minimal tooling to **enforce and replicate GitHub labels** across all repositories
in the `Infra-Coders` organization using **GitHub CLI (`gh`)**.

## Requirements
- Podman
- GitHub CLI (`gh`)
- `jq`
- Access to `Infra-Coders` org
- `podman_gh` wrapper

## Auth (one-time)

Before running any scripts, authenticate GitHub CLI.

```bash
podman_gh auth login
```
Follow the interactive flow:

- Account: **GitHub.com**
- Git protocol: **SSH**
- Upload SSH key: select your public key (e.g. `~/.ssh/id_rsa.pub`)
- Authentication method: **Login with a web browser**

If the container cannot open a browser automatically, you will see:

```text
! First copy your one-time code: XXXX-XXXX
! Failed opening a web browser
Please try entering the URL in your browser manually
```

In that case:
1. Copy the one-time code
2. Open the provided GitHub URL in your local browser
3. Complete authentication

Verify authentication status:

```bash
podman_gh auth status
```

List repositories in the Infra-Coders organization:

```bash
podman_gh repo list Infra-Coders
```

JSON output (used by scripts):

```bash
podman_gh repo list Infra-Coders --json name
```

### Running the sync

```bash
podman_run ./sync-repo-labels.sh
```

## Source of Truth
- Source repo: `Infra-Coders/ic-initiatives`
- Labels are enforced there
- Other repos only receive replicas

## Run
```bash
podman_run ./sync-repo-labels.sh
```

## Notes
- Idempotent
- Uses `--force`
- Whitelist-driven
