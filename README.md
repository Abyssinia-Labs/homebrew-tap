# Abyssinia-Labs Homebrew tap

```sh
brew install abyssinia-labs/tap/latem
latem setup
```

[latem](https://github.com/Abyssinia-Labs/latem) runs your CI on machines you
own. This formula installs a latem release's own archive, for macOS and Linux,
arm64 and x86-64.

## Updating

`brew upgrade latem`. The running agent moves onto the new version by itself,
the first moment no build is in flight, and the service keeps starting
`$(brew --prefix)/opt/latem/bin/latem`, which every upgrade keeps current.
`latem update` is for installs Homebrew does not manage, and refuses this one.

## Where the checksums come from

[`bin/bump`](bin/bump) writes `Formula/latem.rb`. It downloads a release's
checksums manifest and its minisign signature, verifies the signature against
[`latem.pub`](latem.pub), and only then copies each platform's sha256 into the
formula. `latem.pub` is a copy of the key compiled into every latem binary,
`internal/selfupdate/trusted.pub` (key `D73938C642AD64D3`). Homebrew then
checks each download against that sha256, so an install from here rests on the
same signature `install.sh` and `latem update` check.

[`bump.yml`](.github/workflows/bump.yml) runs `bin/bump` hourly, tests the
result on macOS and Linux, and pushes it. To pick a release up at once:

```sh
gh workflow run bump.yml --repo Abyssinia-Labs/homebrew-tap
```

When latem's signing key is rotated, `latem.pub` changes in the same release
(latem's `docs/release.md`, §2).
