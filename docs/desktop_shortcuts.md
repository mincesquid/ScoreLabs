# Make ScoreLabs Easy to Find from the Desktop (macOS)

If ScoreLabs is difficult to find from your desktop, here are several quick options to pin, bookmark, or open the project quickly.

## 1) Create a Desktop symlink (fast)

This is the simplest method — a symlink points to the repository and is searchable from Finder/Spotlight.

```bash
# Create a symlink to the repository on your Desktop
ln -s /path/to/ScoreLabs ~/Desktop/ScoreLabs
```

Benefits: Quick, visible on Desktop, searchable in Spotlight.

## 2) Create a Finder Alias (macOS)

Find the repository folder in Finder, right-click → Make Alias, then move the alias to your Desktop.

You can also use our helper script to create an alias:

```bash
# From repo root
scripts/create_desktop_shortcut.sh --alias
```

## 3) Add the folder to the Dock (right side)

- Drag the `ScoreLabs` folder to the right side of the Dock (near the trash)
- Choose "Stack" or "Fan" view for quick access

## 4) Add to Finder sidebar

- Drag the repository to the "Favorites" section in Finder Sidebar
- This makes it one click away in Finder windows

## 5) Spotlight and Alfred

- Use Spotlight (Cmd+Space) to search for `ScoreLabs`
- Alfred (third-party) can keep project bookmarks for even faster access

## 6) Create a VS Code workspace (double-click to open)

If you use Visual Studio Code, create a `ScoreLabs.code-workspace` at the repo root. Double-clicking the file opens the workspace in VS Code.

```bash
# From repo root (helper creates file)
scripts/create_desktop_shortcut.sh --vscode
```

## 7) Keep in Dock (VS Code) — Quick Open

- Add Visual Studio Code to your Dock
- Drag `ScoreLabs` onto the VS Code icon to pin it to the Recent projects list

## 8) Automation & scripts (optional)

- Use `scripts/create_desktop_shortcut.sh` to create symlink, alias, or workspace in one step
- Add this command as a startup script or Automator Quick Action

## Tips & Troubleshooting

- If Spotlight doesn't find the folder, re-index Spotlight: System Settings → Siri & Spotlight → Spotlight Privacy → Add/Remove folder
- If you prefer a more advanced launcher use Alfred or Raycast and add a custom project bookmark

Need me to create a macOS Automator Quick Action to open the project with one click? Tell me which method you want automated and I’ll add it to the repo (small script + Quick Action description).
