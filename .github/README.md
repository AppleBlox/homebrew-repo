# AppleBlox Homebrew Tap

Official Homebrew tap for [AppleBlox](https://appleblox.com/).

AppleBlox is a Roblox launcher for macOS, featuring DiscordRPC, Fast-flags, and enhancements inspired by Bloxstrap.

## Installation

To add this tap to your Homebrew installation:

```zsh
brew tap AppleBlox/homebrew-repo
```

## Available Casks

### Stable Build

The latest version is available on the [Releases](https://github.com/AppleBlox/appleblox/releases/latest) page.

```zsh
brew install --cask appleblox
```

### Development Builds

For the development version (more unstable but has the latest features and more).

```zsh
brew install --cask appleblox@dev
```

## Supported Architectures

- **arm64**: Apple Silicon Chips such as: M1, M2, M3, etc.
- **x64**: Intel Architecture.
- **universal**: Universal Version.

## Data Safety & Persistence

Uninstalling or updating AppleBlox through Homebrew is safe:

- **Updates**: Your settings, themes, and mods are preserved.
- **Uninstall**: Your data remains intact in `~/Library/Application Support/AppleBlox`.
- **Full Cleanup**: To remove the app and its caches/preferences (safely excluding user data in `Application Support`), run:

  ```zsh
  brew uninstall --zap appleblox
  ```

## Maintenance & Automation

This tap is powered by a GitHub Actions workflow that automatically:

1. **Stable**: Monitors official GitHub releases for `appleblox`.
2. **Dev**: Monitors the `dev` branch `package.json` for `appleblox@dev`.
3. **Updates**: Calculates new SHA256 hashes and bumps the casks automatically.
