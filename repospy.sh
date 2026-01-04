#!/usr/bin/env bash
# Quick and dirty script to enumerate git token access and repo access
set -euo pipefail

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1" >&2; exit 1; }; }
need curl
need jq
need git

API_DEFAULT="https://api.github.com"

echo "GitHub Token Access + Clone Wizard"
echo "----------------------------------"
echo

read -r -p "GitHub API base [$API_DEFAULT]: " api_in
API="${api_in:-$API_DEFAULT}"

read -r -s -p "Paste GitHub token (input hidden): " TOKEN
echo
if [[ -z "${TOKEN}" ]]; then
  echo "No token supplied. Exiting." >&2
  exit 1
fi

AUTH_HDR="Authorization: token $TOKEN"

echo
echo "[1/6] Checking token validity and identity..."
TMP_HEADERS="$(mktemp)"
TMP_BODY="$(mktemp)"

cleanup() {
  rm -f "$TMP_HEADERS" "$TMP_BODY"
  [[ -n "${GIT_ASKPASS:-}" ]] && rm -f "${GIT_ASKPASS:-}" || true
}
trap cleanup EXIT

curl -sS -D "$TMP_HEADERS" -o "$TMP_BODY" -H "$AUTH_HDR" "$API/user" || true
HTTP_CODE="$(awk 'NR==1{print $2}' "$TMP_HEADERS" 2>/dev/null || true)"

if [[ "${HTTP_CODE}" != "200" ]]; then
  echo "Auth failed. HTTP status: ${HTTP_CODE:-unknown}" >&2
  echo "Body:" >&2
  cat "$TMP_BODY" | head -c 2000 >&2; echo >&2
  exit 1
fi

LOGIN="$(jq -r '.login' < "$TMP_BODY")"
ID="$(jq -r '.id' < "$TMP_BODY")"
echo "Authenticated as: $LOGIN (id: $ID)"

# Classic PAT scopes appear in X-OAuth-Scopes
OAUTH_SCOPES="$(grep -i '^x-oauth-scopes:' "$TMP_HEADERS" | sed -E 's/^x-oauth-scopes:\s*//I' | tr -d '\r' || true)"
if [[ -n "$OAUTH_SCOPES" ]]; then
  echo "Token type: Classic PAT (scopes exposed)"
  echo "Scopes: $OAUTH_SCOPES"
else
  echo "Token type: Likely fine-grained PAT or GitHub App token (scopes not exposed via X-OAuth-Scopes)."
fi

echo
read -r -p "Output directory for clones [./github-backup]: " OUTDIR
OUTDIR="${OUTDIR:-./github-backup}"
mkdir -p "$OUTDIR"

echo
echo "[2/6] Configuring non-interactive git authentication (no prompts)..."


export GIT_TERMINAL_PROMPT=0
export GIT_ASKPASS="$(mktemp)"
chmod 700 "$GIT_ASKPASS"

cat > "$GIT_ASKPASS" <<'EOF'
#!/usr/bin/env sh
case "$1" in
  *Username*) echo "$GIT_USERNAME" ;;
  *Password*) echo "$GIT_PASSWORD" ;;
  *) echo "" ;;
esac
EOF

# Credentials for askpass helper
export GIT_USERNAME="$LOGIN"
export GIT_PASSWORD="$TOKEN"

echo "Git will authenticate as: $GIT_USERNAME"
echo "Interactive prompts disabled."

echo
echo "[3/6] Enumerating accessible repositories..."
echo "This may take a moment if you have many repos."

REPO_PAGES="$(mktemp)"
: > "$REPO_PAGES"

page=1
while :; do
  resp="$(curl -sS -H "$AUTH_HDR" \
    "$API/user/repos?per_page=100&page=$page&affiliation=owner,collaborator,organization_member")"

  count="$(echo "$resp" | jq 'length')"
  if [[ "$count" -eq 0 ]]; then
    break
  fi

  echo "$resp" >> "$REPO_PAGES"
  page=$((page + 1))
done

ALL_REPOS="$(jq -s 'add' "$REPO_PAGES")"
rm -f "$REPO_PAGES"

TOTAL="$(echo "$ALL_REPOS" | jq 'length')"
echo "Repos found: $TOTAL"

if [[ "$TOTAL" -eq 0 ]]; then
  echo "No repos visible to this token. Exiting."
  exit 0
fi

echo
echo "[4/6] Building a permissions report..."
REPORT="$OUTDIR/repo-access-report.tsv"
echo -e "full_name\tprivate\tdefault_branch\tpull\tpush\tadmin\tclone_url\tssh_url" > "$REPORT"

echo "$ALL_REPOS" | jq -r '
  .[] |
  [
    .full_name,
    (.private|tostring),
    .default_branch,
    (.permissions.pull|tostring),
    (.permissions.push|tostring),
    (.permissions.admin|tostring),
    .clone_url,
    .ssh_url
  ] | @tsv
' >> "$REPORT"

echo "Report written to: $REPORT"
echo "Top entries:"
head -n 10 "$REPORT" | column -t -s $'\t' || head -n 10 "$REPORT"

echo
echo "[5/6] Clone mode selection:"
echo "  1) Normal clone (working tree)      - good for browsing/editing"
echo "  2) Mirror clone (bare --mirror)     - best for backup/IR"
read -r -p "Choose [1]: " MODE
MODE="${MODE:-1}"

echo
read -r -p "Clone only repos with push access? (y/N): " ONLY_PUSH
ONLY_PUSH="${ONLY_PUSH:-N}"

clone_repo() {
  local full_name="$1"
  local clone_url="$2"
  local target_dir="$3"
  local mirror="$4"

  if [[ "$mirror" == "1" ]]; then
    git clone --mirror "$clone_url" "$target_dir"
  else
    git clone "$clone_url" "$target_dir"
  fi
}

echo
echo "[6/6] Cloning repositories into: $OUTDIR"
echo

echo "$ALL_REPOS" | jq -r '
  .[] |
  [
    .full_name,
    .clone_url,
    (.permissions.push|tostring)
  ] | @tsv
' | while IFS=$'\t' read -r full clone_url can_push; do
  if [[ "$ONLY_PUSH" =~ ^[Yy]$ ]] && [[ "$can_push" != "true" ]]; then
    echo "SKIP (no push): $full"
    continue
  fi

  org="${full%%/*}"
  name="${full##*/}"
  mkdir -p "$OUTDIR/$org"

  if [[ "$MODE" == "2" ]]; then
    dest="$OUTDIR/$org/$name.git"
    echo "MIRROR: $full -> $dest"
    if ! clone_repo "$full" "$clone_url" "$dest" "1"; then
      echo "FAILED: $full" >&2
    fi
  else
    dest="$OUTDIR/$org/$name"
    echo "CLONE : $full -> $dest"
    if ! clone_repo "$full" "$clone_url" "$dest" "0"; then
      echo "FAILED: $full" >&2
    fi
  fi
done

echo
echo "Done."
echo "Repo access report: $REPORT"

# Best-effort cleanup of sensitive env vars
unset GIT_USERNAME GIT_PASSWORD GIT_TERMINAL_PROMPT GIT_ASKPASS
