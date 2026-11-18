# Abyssinia-Labs Homebrew tap

```sh
brew install abyssinia-labs/tap/latem
latem setup

brew install abyssinia-labs/tap/latem-vault
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

## latem vault

[latem vault](https://github.com/Abyssinia-Labs/latem-vault) keeps secrets,
variables and files encrypted on your own devices. `Formula/latem-vault.rb`
installs a release's own archive, for the same four platforms, the same way:
[`bin/bump-latem-vault`](bin/bump-latem-vault) verifies the release's
checksums manifest against [`latem-vault.pub`](latem-vault.pub), latem vault's
own release key (`3AE5705FBEDAB5B2`, not latem's), before it writes a sha256.
[`bump-latem-vault.yml`](.github/workflows/bump-latem-vault.yml) runs it
hourly, tests the formula on macOS and Linux, and pushes it:

```sh
gh workflow run bump-latem-vault.yml --repo Abyssinia-Labs/homebrew-tap
```

For 0.6, the release that renamed OpenVault, the formula also installs an
`openvault` command that says the new name and runs `latem-vault`. OV-15 takes
it out. When latem vault's key is rotated, `latem-vault.pub` changes here
before the first release the new key signs (latem-vault's `docs/release.md`).
