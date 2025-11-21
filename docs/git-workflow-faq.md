# Git Workflow FAQ

Common git scenarios and solutions for ScoreLabs contributors.

## Setup

### I just cloned the repository. What should I do first?

Run the setup script to ensure proper git configuration:

```bash
cd ScoreLabs
./scripts/setup-git.sh
```

This will:
- Configure git to fetch all branches
- Fetch all remote branches
- Optionally create a local `main` branch

## Working with Branches

### How do I see all available branches?

```bash
git branch -a
```

### How do I create a local main branch?

```bash
# First, run setup to see all remote branches
./scripts/setup-git.sh

# Create local main from origin/main
git checkout -b main origin/main
```

### How do I switch to the main branch?

```bash
# If you don't have a local main branch yet
git checkout -b main origin/main

# If you already have a local main branch
git checkout main
```

### How do I create a new feature branch?

```bash
# Make sure you're on main and it's up to date
git checkout main
git pull origin main

# Create and switch to a new branch
git checkout -b feature/my-new-feature
```

## Merging

### How do I merge changes from main into my branch?

```bash
# Make sure you can see all branches
./scripts/setup-git.sh

# From your feature branch
git merge origin/main
```

### How do I merge OS assets or other branches?

```bash
# First, ensure you can see all branches
./scripts/setup-git.sh

# See what branches are available
git branch -a

# Merge from any remote branch
git merge origin/branch-name
```

## Pushing Changes

### How do I push my changes?

```bash
# Add your changes
git add .

# Commit your changes
git commit -m "Description of changes"

# Push to your branch
git push origin your-branch-name

# Or set upstream and push
git push -u origin your-branch-name
```

### I get "non-fast-forward" error when pushing

Your local branch is behind the remote. Update it first:

```bash
# Pull the latest changes
git pull origin your-branch-name

# Or if you want to see branches first
./scripts/setup-git.sh
git pull origin your-branch-name

# Then push
git push origin your-branch-name
```

### I get "src refspec main does not match any"

You don't have a local `main` branch. Create one:

```bash
./scripts/setup-git.sh
git checkout -b main origin/main
```

## Troubleshooting

### I can't see the main branch

Run the setup script to fix git configuration:

```bash
./scripts/setup-git.sh
```

### I get "does not have a commit checked out" error

Make sure you're in the repository root directory:

```bash
# Check where you are
pwd

# Go to repository root
cd /path/to/ScoreLabs

# Verify you're in the right place
git rev-parse --show-toplevel
```

### How do I undo uncommitted changes?

```bash
# Undo changes to a specific file
git checkout -- filename

# Undo all uncommitted changes
git reset --hard HEAD
```

### How do I undo my last commit (but keep changes)?

```bash
git reset --soft HEAD~1
```

### How do I undo my last commit (and discard changes)?

```bash
git reset --hard HEAD~1
```

## Best Practices

### Before starting work

1. Run `./scripts/setup-git.sh` to ensure proper configuration
2. Make sure you're on the right branch: `git branch`
3. Pull latest changes: `git pull origin main`
4. Create a feature branch: `git checkout -b feature/my-feature`

### Before committing

1. Check what files changed: `git status`
2. Review your changes: `git diff`
3. Add only what you need: `git add file1 file2` or `git add .`
4. Write a clear commit message: `git commit -m "Clear description"`

### Before pushing

1. Make sure tests pass (if any)
2. Pull latest changes: `git pull origin main`
3. Resolve any merge conflicts
4. Push your changes: `git push origin your-branch`

## Resources

- [Git Troubleshooting Guide](git-troubleshooting.md)
- [Contributing Guidelines](../CONTRIBUTING.md)
- [Official Git Documentation](https://git-scm.com/doc)
- [Pro Git Book (Free)](https://git-scm.com/book/en/v2)
