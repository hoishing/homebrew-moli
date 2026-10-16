# Hoishing Tap

## Install

```sh
brew install hoishing/tap/moli
```

Or `brew tap hoishing/tap` and then `brew install <formula>`.

## Formulae

| Formula | Description |
|---|---|
| `moli` | [lexmount/moli](https://github.com/lexmount/moli) headless browser for AI agents (prebuilt release binaries) |

## Auto update

`.github/workflows/update-moli.yml` checks the latest moli release daily,
updates the version and sha256 digests via `scripts/update-moli.sh`,
verifies the formula with `brew install` and `brew test`, then commits to `main`.
