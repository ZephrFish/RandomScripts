#!/bin/bash
# git-email-rewrite.sh - Rewrite git commit history to change email addresses
# Usage: ./git-email-rewrite.sh <old_email_or_pattern> <new_email> <new_name> <repos_file> [--pattern]
# Example: ./git-email-rewrite.sh "old@email.com" "new@email.com" "New Name" repos.txt
# Example: ./git-email-rewrite.sh "@olddomain.com" "new@email.com" "New Name" repos.txt --pattern

set -e

usage() {
  echo "Usage: $0 <old_email_or_pattern> <new_email> <new_name> <repos_file> [--pattern]"
  echo ""
  echo "Arguments:"
  echo "  old_email_or_pattern - Exact email or pattern to match (use --pattern for grep matching)"
  echo "  new_email            - New email address to use"
  echo "  new_name             - New author/committer name to use"
  echo "  repos_file           - File containing list of repo URLs (one per line)"
  echo "  --pattern            - Treat old_email as a grep pattern instead of exact match"
  echo ""
  echo "Examples:"
  echo "  # Exact email match:"
  echo "  $0 'olduser@gmail.com' 'newuser@domain.com' 'New Name' repos.txt"
  echo ""
  echo "  # Pattern match (any email containing '@olddomain.com'):"
  echo "  $0 '@olddomain.com' 'newuser@domain.com' 'New Name' repos.txt --pattern"
  exit 1
}

if [ $# -lt 4 ]; then
  usage
fi

OLD_EMAIL="$1"
NEW_EMAIL="$2"
NEW_NAME="$3"
REPOS_FILE="$4"
USE_PATTERN=false

if [ "$5" = "--pattern" ]; then
  USE_PATTERN=true
fi

if [ ! -f "$REPOS_FILE" ]; then
  echo "Error: Repos file not found: $REPOS_FILE"
  exit 1
fi

WORK_DIR=$(mktemp -d)
trap "rm -rf $WORK_DIR" EXIT

echo "Git Email Rewriter"
echo "=================="
echo "Old email/pattern: $OLD_EMAIL"
echo "New email: $NEW_EMAIL"
echo "New name: $NEW_NAME"
echo "Repos file: $REPOS_FILE"
echo "Pattern mode: $USE_PATTERN"
echo ""

if $USE_PATTERN; then
  FILTER_SCRIPT="
    if echo \"\$GIT_AUTHOR_EMAIL\" | grep -qi '$OLD_EMAIL'; then
      export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
      export GIT_AUTHOR_NAME='$NEW_NAME'
    fi
    if echo \"\$GIT_COMMITTER_EMAIL\" | grep -qi '$OLD_EMAIL'; then
      export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
      export GIT_COMMITTER_NAME='$NEW_NAME'
    fi
  "
else
  FILTER_SCRIPT="
    if [ \"\$GIT_AUTHOR_EMAIL\" = '$OLD_EMAIL' ]; then
      export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
      export GIT_AUTHOR_NAME='$NEW_NAME'
    fi
    if [ \"\$GIT_COMMITTER_EMAIL\" = '$OLD_EMAIL' ]; then
      export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
      export GIT_COMMITTER_NAME='$NEW_NAME'
    fi
  "
fi

SUCCESS=0
FAILED=0
SKIPPED=0

while read -r repo_url; do
  [ -z "$repo_url" ] && continue
  repo_name=$(basename "$repo_url" .git)
  echo "=== Processing: $repo_name ==="

  rm -rf "$WORK_DIR/$repo_name"

  if ! git clone "$repo_url" "$WORK_DIR/$repo_name" 2>/dev/null; then
    echo "SKIP: $repo_name (clone failed)"
    ((SKIPPED++))
    continue
  fi

  cd "$WORK_DIR/$repo_name"

  FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter "$FILTER_SCRIPT" --tag-name-filter cat -- --all 2>/dev/null || true

  if git push --force --all 2>&1; then
    git push --force --tags 2>&1 || true
    echo "DONE: $repo_name"
    ((SUCCESS++))
  else
    echo "FAILED: $repo_name (push failed - may be archived)"
    ((FAILED++))
  fi

  cd - > /dev/null
  rm -rf "$WORK_DIR/$repo_name"
done < "$REPOS_FILE"

echo ""
echo "=== Summary ==="
echo "Success: $SUCCESS"
echo "Failed: $FAILED"
echo "Skipped: $SKIPPED"
echo "Total: $((SUCCESS + FAILED + SKIPPED))"
