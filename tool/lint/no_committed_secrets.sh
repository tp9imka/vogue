#!/usr/bin/env bash
# Fails when tracked files contain common secret shapes.
#
# Part of tool/dev/check.sh. Run on its own with:
#   bash tool/lint/no_committed_secrets.sh
#
# The check is intentionally conservative — false positives are loud and
# easy to allow-list (skip the file with a :! pathspec below). False
# negatives mean a credential ends up on GitHub.
set -euo pipefail
cd "$(dirname "$0")/../.."

fail=0
report() {
  local label="$1"
  shift
  if git grep -inE "$@" >/dev/null 2>&1; then
    echo "✗ $label"
    git grep -inE "$@"
    fail=1
  fi
}

# Pathspec excludes — files allowed to mention the patterns descriptively
# (the lint script itself, docs that document the rules).
excludes=(
  ':!tool/lint/no_committed_secrets.sh'
  ':!AGENTS.md'
  ':!RELEASE.md'
)

# Android signing — passwords belong only in the gitignored key.properties
report 'Plaintext storePassword' '^[[:space:]]*storePassword=[^[:space:]]+' "${excludes[@]}"
report 'Plaintext keyPassword'   '^[[:space:]]*keyPassword=[^[:space:]]+'   "${excludes[@]}"

# Generic cloud-provider key shapes
report 'AWS access key id'   'AKIA[0-9A-Z]{16}'                     "${excludes[@]}"
report 'AWS secret literal'  'aws_secret_access_key[[:space:]]*=' "${excludes[@]}"
report 'Google API key'      'AIza[0-9A-Za-z_-]{35}'                "${excludes[@]}"
report 'OpenAI-style secret' 'sk-[A-Za-z0-9]{32,}'                  "${excludes[@]}"
report 'GitHub PAT'          '(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{36}' "${excludes[@]}"
report 'Slack token'         'xox[abp]-[A-Za-z0-9-]{10,}'           "${excludes[@]}"

# Inline private keys
report 'Inline private key block' 'BEGIN (RSA |EC |OPENSSH |DSA |ENCRYPTED )?PRIVATE KEY' "${excludes[@]}"

if [ "$fail" -ne 0 ]; then
  echo
  echo "Likely secrets found in tracked files."
  echo "Rotate the credential first, then purge it from git history."
  echo "See AGENTS.md § Secrets and sensitive content."
  exit 1
fi

echo "OK"
