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

## Still Having Issues?

If you're still experiencing problems:

1. Check your git version: `git --version` (should be 2.0 or higher)
2. Verify your remote URL: `git remote -v`
3. Check network connectivity: `git ls-remote origin`
4. Review git logs: `git config --list | grep remote`

For additional help, see [CONTRIBUTING.md](../CONTRIBUTING.md) or open an issue on GitHub.