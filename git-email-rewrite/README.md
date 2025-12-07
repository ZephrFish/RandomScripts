# Git Email Rewrite Tools

Scripts to scan and rewrite email addresses in git commit history across multiple repositories.

## Scripts

### git-email-scan.sh
Scans repositories for commits containing a specific email pattern.

```bash
./git-email-scan.sh <email_pattern> <repos_file> [output_dir]

# Examples:
./git-email-scan.sh "@olddomain.com" repos.txt ./scan_results
./git-email-scan.sh "olduser@gmail.com" my_repos.txt
```

**Output:**
- `found_emails.txt` - All matching emails found
- `needs_rewrite.txt` - Repo URLs that need rewriting

### git-email-rewrite.sh
Rewrites commit history to replace email addresses.

```bash
./git-email-rewrite.sh <old_email> <new_email> <new_name> <repos_file> [--pattern]

# Exact email match:
./git-email-rewrite.sh "old@email.com" "new@email.com" "New Name" repos.txt

# Pattern match (any email containing the pattern):
./git-email-rewrite.sh "@olddomain.com" "new@email.com" "New Name" repos.txt --pattern
```

## Workflow

1. Create a file with repo URLs (one per line):
   ```
   git@github.com:user/repo1.git
   git@github.com:user/repo2.git
   ```

2. Scan for emails to find which repos need rewriting:
   ```bash
   ./git-email-scan.sh "@olddomain.com" repos.txt ./output
   ```

3. Review `output/needs_rewrite.txt` and `output/found_emails.txt`

4. Run the rewrite:
   ```bash
   ./git-email-rewrite.sh "@olddomain.com" "new@email.com" "New Name" output/needs_rewrite.txt --pattern
   ```

## Requirements
- git
- SSH key with push access to target repos
- Repos must not be archived (read-only repos will fail to push)

## Warning
This rewrites git history and force pushes. Use with caution on shared repositories.
