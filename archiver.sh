#!/bin/bash

if date --version >/dev/null 2>&1; then
  # GNU date (Linux)
  four_years_ago=$(date -d '4 years ago' --iso-8601=seconds)
else
  # BSD/macOS date
  four_years_ago=$(date -v-4y +"%Y-%m-%dT%H:%M:%SZ")
fi

for repo_dir in temp/*; do
  if [ -d "$repo_dir/.git" ]; then
    (
      cd "$repo_dir" || exit 1

      remote_url=$(git config --get remote.origin.url)
      repo_fullname=$(echo "$remote_url" | sed -E 's#(git@|https://)github.com[:/](.+)\.git#\2#')

      second_commit_date=$(git log --pretty=format:"%cI" | sed -n '2p')

      if [ -n "$second_commit_date" ]; then
        if [[ "$second_commit_date" < "$four_years_ago" ]]; then
          echo "Archiving repo: $repo_fullname (second last commit: $second_commit_date)"
          gh api -X PATCH "repos/$repo_fullname" -f archived=true
        else
          echo "Skipping repo: $repo_fullname (second last commit: $second_commit_date)"
        fi
      else
        echo "Skipping repo: $repo_fullname (only one commit found)"
      fi
    )
  fi
done
