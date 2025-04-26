for repo_dir in temp/*; do
  if [ -d "$repo_dir/.git" ]; then
    echo "* @zephrfish" > "$repo_dir/CODEOWNERS"

    mkdir -p "$repo_dir/.github"
    echo "* @zephrfish" > "$repo_dir/.github/CODEOWNERS"

    (
      cd "$repo_dir"
      git add .
      git commit -m "Added CODEOWNERS file"
      git push
    )
  fi
done
