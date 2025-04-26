for repo_dir in temp/*; do
  if [ -d "$repo_dir/.git" ]; then
    (
      cd "$repo_dir"

      current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)

      if [ "$current_branch" = "master" ]; then
        echo "[$repo_dir] Renaming branch master -> main"

        git branch -m master main   
        git fetch origin            
        git push origin main        

        remote_url=$(git config --get remote.origin.url)
        repo_fullname=$(echo "$remote_url" | sed -E 's#(git@|https://)github.com[:/](.+)\.git#\2#')

        echo "Setting default branch to main for $repo_fullname"
        gh repo edit "$repo_fullname" --default-branch main

        git push origin --delete master || true

      else
        echo "[$repo_dir] Already on branch $current_branch, skipping"
      fi
    )
  fi
done