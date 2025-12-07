# Git Email Rewrite Tools

## Usage

### Scan for emails
```bash
./git-email-scan.sh <email_pattern> <repos_file> [output_dir]
```

### Rewrite emails
```bash
# Exact match
./git-email-rewrite.sh <old_email> <new_email> <new_name> <repos_file>

# Pattern match
./git-email-rewrite.sh <pattern> <new_email> <new_name> <repos_file> --pattern
```
