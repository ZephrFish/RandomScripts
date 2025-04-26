mkdir -p temp
for x in $(gh api --paginate '/user/repos?affiliation=owner' | jq -r '.[] | select(.private == true and .fork == false) | .ssh_url'); do
  repo_name=$(basename -s .git "$x")
  git clone "$x" "temp/$repo_name"
done
