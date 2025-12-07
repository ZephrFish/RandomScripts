#!/bin/bash
# git-email-scan.sh - Scan GitHub repos for commits with matching email pattern
# Usage: ./git-email-scan.sh <email_pattern> <repos_file> [output_dir]
# Example: ./git-email-scan.sh "@zsec.uk" repos.txt ./output

set -e

if [ $# -lt 2 ]; then
  echo "Usage: $0 <email_pattern> <repos_file> [output_dir]"
  echo ""
  echo "Arguments:"
  echo "  email_pattern  - Email pattern to search for (e.g., 'user@domain.com' or '@domain.com')"
  echo "  repos_file     - File containing list of repo URLs (one per line)"
  echo "  output_dir     - Output directory (default: current directory)"
  echo ""
  echo "Example:"
  echo "  $0 '@zsec.uk' repos.txt ./scan_results"
  echo "  $0 'olduser@gmail.com' my_repos.txt"
  exit 1
fi

EMAIL_PATTERN="$1"
REPOS_FILE="$2"
OUTPUT_DIR="${3:-.}"

mkdir -p "$OUTPUT_DIR"

EMAILS_FILE="$OUTPUT_DIR/found_emails.txt"
NEEDS_REWRITE_FILE="$OUTPUT_DIR/needs_rewrite.txt"

rm -f "$EMAILS_FILE" "$NEEDS_REWRITE_FILE"
touch "$EMAILS_FILE" "$NEEDS_REWRITE_FILE"

echo "Scanning for emails matching: $EMAIL_PATTERN"
echo "Reading repos from: $REPOS_FILE"
echo "Output directory: $OUTPUT_DIR"
echo ""

TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

while read -r repo_url; do
  [ -z "$repo_url" ] && continue
  repo_name=$(basename "$repo_url" .git)

  rm -rf "$TEMP_DIR/$repo_name"
  if git clone --bare --quiet "$repo_url" "$TEMP_DIR/$repo_name" 2>/dev/null; then
    emails=$(git -C "$TEMP_DIR/$repo_name" log --all --format='%ae %ce' 2>/dev/null | tr ' ' '\n' | grep -i "$EMAIL_PATTERN" | sort -u)
    if [ -n "$emails" ]; then
      echo "$repo_url" >> "$NEEDS_REWRITE_FILE"
      echo "$emails" >> "$EMAILS_FILE"
      echo "FOUND: $repo_name - $emails"
    else
      echo "CLEAN: $repo_name"
    fi
    rm -rf "$TEMP_DIR/$repo_name"
  else
    echo "SKIP: $repo_name (clone failed)"
  fi
done < "$REPOS_FILE"

echo ""
echo "=== Unique emails found ==="
sort -u "$EMAILS_FILE"
echo ""
echo "=== Repos needing rewrite ==="
cat "$NEEDS_REWRITE_FILE"
echo ""
echo "Count: $(wc -l < "$NEEDS_REWRITE_FILE") repos need rewriting"
echo ""
echo "Output files:"
echo "  - $EMAILS_FILE"
echo "  - $NEEDS_REWRITE_FILE"
