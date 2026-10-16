# Moli Tap

Homebrew tap for [Moli](https://github.com/lexmount/moli), a headless browser for AI agents built in Rust.

## Install

```sh
brew install hoishing/moli/moli
```

Installs:

- `moli` binary (prebuilt release for macOS / Linux, arm64 / x86_64)
- Official Moli agent skills, pinned to the same release:
  - `moli-webfetch`
  - `moli-websearch`
  - `moli-cdp-server`

## Link the skills

Skills are installed to `$(brew --prefix)/opt/moli/share/moli/skills`.
Symlink them into your agent's skills directory:

```sh
mkdir -p ~/.agents/skills
for s in "$(brew --prefix)"/opt/moli/share/moli/skills/*; do
  ln -sfn "$s" ~/.agents/skills/
done
```

- Replace `~/.agents/skills` with your agent's path, e.g. `~/.claude/skills` for Claude Code.
- Links point to the stable `opt` path, not a versioned Cellar path.

## Update

```sh
brew upgrade moli
```

- Binary and skills upgrade together.
- Linked skills update automatically, no relinking needed.
- Re-run the link loop only when a release adds a new skill.
- Remove dangling links if a release drops a skill.

## Auto update

`.github/workflows/update-moli.yml` checks the latest Moli release daily:

1. Updates version and sha256 digests (binaries and `skills` resource) via `scripts/update-moli.sh`
2. Verifies with `brew style`, `brew install` and `brew test`
3. Commits to `main`
