#!/usr/bin/env bash
set -euo pipefail

ORG="Infra-Coders"
SOURCE_REPO="ic-initiatives"

# ==========================================================
# Label whitelist (SOURCE OF TRUTH)
# name | description
# ==========================================================
LABELS=(
  "work/go|Go source code"
  "work/bash|Shell scripts"
  "work/ci|Continuous integration"
  "work/gitops|GitOps manifests (Flux / Argo)"
  "work/terraform|Terraform / IaC"
  "work/integration|Integration / glue code"
  "work/demo|Demo and examples"
  "work/docs|Documentation"
  "type/task|Implementation task"
  "type/learning|Learning / educational task"
  "type/spike|Spike / research"
  "area/kubernetes|Kubernetes related"
  "area/security|Security related"
  "area/pki|PKI and certificates"
)

# ==========================================================
# Helpers
# ==========================================================
color_from_name() {
  # deterministic color based on label name
  echo -n "$1" | sha1sum | cut -c1-6
}

echo "Enforcing labels on source repo: $ORG/$SOURCE_REPO"

for entry in "${LABELS[@]}"; do
  NAME="${entry%%|*}"
  DESC="${entry##*|}"
  COLOR="$(color_from_name "$NAME")"

  gh label create "$NAME" \
    --description "$DESC" \
    --color "$COLOR" \
    -R "$ORG/$SOURCE_REPO" \
    --force >/dev/null

  echo "  ✔ enforced $NAME ($COLOR)"
done

echo
echo "Fetching repositories from organization: $ORG"

REPOS=$(gh repo list "$ORG" --json name --jq '.[].name')

for REPO in $REPOS; do
  if [[ "$REPO" == "$SOURCE_REPO" ]]; then
    echo "Skipping source repo: $REPO"
    continue
  fi

  echo "Replicating labels to $ORG/$REPO"

  for entry in "${LABELS[@]}"; do
    NAME="${entry%%|*}"
    DESC="${entry##*|}"
    COLOR="$(color_from_name "$NAME")"

    gh label create "$NAME" \
      --description "$DESC" \
      --color "$COLOR" \
      -R "$ORG/$REPO" \
      --force >/dev/null
  done
done

echo
echo "Label enforcement and replication completed"
