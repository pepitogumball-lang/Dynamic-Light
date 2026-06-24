# Dynamic Light — Minecraft Bedrock Addon

A collaborative Minecraft Bedrock Edition addon (v1.21.132) implementing:
1. **Dynamic Lighting** — torches and luminous items illuminate surroundings when held in hand
2. **Universal Off-Hand** — equip any item in the off-hand slot (bypasses Bedrock mobile restriction)
3. **Off-Hand Placement** — block/item placement via right-click interaction from the off-hand

## Project Structure

- `Behavior_Pack/` — Server-side logic and entity definitions (scripts + JSON)
- `Resource_Pack/` — Client-side visuals: attachables, animations, animation controllers
- `build_verify/` — Pre-built `.mcaddon` artifact for verification
- `.github/workflows/build.yml` — CI/CD pipeline that packages into `.mcpack` and `.mcaddon`
- `push.py` — Helper script to commit and push changes (triggers the CI build)

## How to Build

This addon is **not a web app**. It runs inside Minecraft Bedrock Edition.

To package the addon:
- Push changes to GitHub — the Actions workflow will automatically create a `.mcaddon` artifact
- Or use `push.py` to automate the git workflow: `python3 push.py`

Check build status with: `gh run list --limit 5`

## Development Notes

- The scripting entry point is `Behavior_Pack/scripts/main.js` (uses `@minecraft/server` API v1.14.0)
- Manifests are in `Behavior_Pack/manifest.json` and `Resource_Pack/manifest.json`
- Target: Minecraft Bedrock 1.21.132+

## User Preferences

- Development language in README is Spanish
