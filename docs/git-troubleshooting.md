# Git Configuration Troubleshooting

This guide helps resolve common git configuration issues in the ScoreLabs repository.

## Common Issue: Unable to Merge Branches

### Symptom

You cannot see or merge branches from the remote repository, such as:
- The `main` branch
- OS assets branches
- Other feature branches

### Cause

The git remote fetch configuration is set to only fetch the current branch instead of all branches.

### Quick Fix

Run the setup script:

```bash
./scripts/setup-git.sh
```

This will automatically configure git to fetch all branches from the remote.

### Manual Fix

If you prefer to fix this manually:

1. **Check current configuration:**
   ```bash
   git config --get remote.origin.fetch
   ```

2. **Update the configuration:**
   ```bash
   git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
   ```

3. **Fetch all branches:**
   ```bash
   git fetch origin
   ```

4. **Verify all branches are visible:**
   ```bash
   git branch -a
   ```

You should now see:
- `remotes/origin/main`
- `remotes/origin/<other-branches>`

### Understanding the Configuration

**Restricted (problematic):**
```
+refs/heads/copilot/fix-merge-issue-with-scorelabs:refs/remotes/origin/copilot/fix-merge-issue-with-scorelabs
```
- This only fetches one specific branch

**Correct (recommended):**
```
+refs/heads/*:refs/remotes/origin/*
```
- This fetches all branches from the remote

## Testing Your Configuration

After updating your git configuration, test that you can merge:

```bash
# See all available branches
git branch -a

# Test merging from main (dry run)
git merge --no-commit --no-ff origin/main

# If successful, abort the test merge
git merge --abort
```

## Merging OS Assets or Other Branches

Once your git configuration is correct, you can merge any branch:

```bash
# Merge from main
git merge origin/main

# Merge from a specific branch
git merge origin/os-assets

# Merge with a specific strategy
git merge --no-ff origin/feature-branch
```

## Preventing This Issue

When cloning the repository, ensure you clone with all branches:

```bash
# Clone the repository
git clone https://github.com/mincesquid/ScoreLabs.git
cd ScoreLabs

# Immediately run the setup script
./scripts/setup-git.sh
```

## Additional Resources

- [Git Remote Documentation](https://git-scm.com/docs/git-remote)
- [Git Fetch Documentation](https://git-scm.com/docs/git-fetch)
- [Git Merge Documentation](https://git-scm.com/docs/git-merge)

## Common Git Push/Pull Errors

### Error: "non-fast-forward" or "tip of your current branch is behind"

This means your local branch is behind the remote. Fix with:

```bash
# First, ensure you can see all branches
./scripts/setup-git.sh

# If you want to work on main, create a local main branch from origin/main
git checkout -b main origin/main

# Or if you have a local main branch, pull the latest changes
git checkout main
git pull origin main
```

### Error: "src refspec main does not match any"

You don't have a local `main` branch. Create one:

```bash
# First, ensure you can see all branches
./scripts/setup-git.sh

# Create and checkout main branch from origin
git checkout -b main origin/main
```

### Error: "'ScoreLabs/' does not have a commit checked out"

This error occurs when running `git add` in the wrong directory or with incorrect paths. Fix with:

```bash
# Make sure you're in the repository root
cd /path/to/ScoreLabs

# Use proper git add commands
git add .               # Add all changes in current directory
git add -A              # Add all changes in the entire repository
git add file.txt        # Add a specific file
```

**Note:** Don't use `git add -A -- .` as the `-- .` is redundant and can cause issues.

## Still Having Issues?

If you're still experiencing problems:

1. Check your git version: `git --version` (should be 2.0 or higher)
2. Verify your remote URL: `git remote -v`
3. Check network connectivity: `git ls-remote origin`
4. Review git configuration: `git config --list | grep remote`
5. Verify you're in the repository root: `git rev-parse --show-toplevel`

For additional help, see [CONTRIBUTING.md](../CONTRIBUTING.md) or open an issue on GitHub.