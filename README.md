# ph-wolf Homebrew tap

Versioned command-line tools maintained by Philipp Wolf.

## beatpick

Find your rhythm. AI-assisted playlists for Apple Music.

```sh
brew install ph-wolf/tap/beatpick
beatpick --version
```

Requires macOS. Homebrew manages Python, FFmpeg, NumPy, SciPy and PyYAML.
The package includes the optional AI skill from the same release.
See [beatpick](https://github.com/ph-wolf/beatpick#readme) for configuration,
preview/application, skill setup, and development documentation.

```sh
brew update
brew upgrade beatpick
```

Personal configuration and analysis data are not stored in this repository
and are not replaced by Homebrew upgrades.

## Maintaining a release

Publish a versioned release in the upstream project first. Update the formula's
version, immutable release asset URL and SHA-256 together. Test with
`brew reinstall ph-wolf/tap/beatpick` and `brew test ph-wolf/tap/beatpick`.
The functional test never accesses or modifies the user's Music library.

Licensed under MIT.
