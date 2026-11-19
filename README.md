# Abyssinia-Labs Homebrew tap

```sh
brew install abyssinia-labs/tap/latem
latem setup

brew install abyssinia-labs/tap/pinkvault
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

## PinkVault

[PinkVault](https://github.com/Abyssinia-Labs/latem-vault) keeps secrets,
variables and files encrypted on your own devices. `Formula/pinkvault.rb`
installs a release's own archive, for the same four platforms, the same way:
[`bin/bump-pinkvault`](bin/bump-pinkvault) verifies the release's checksums
manifest against [`pinkvault.pub`](pinkvault.pub), PinkVault's own release key
(`3AE5705FBEDAB5B2`, not latem's), before it writes a sha256.
[`bump-pinkvault.yml`](.github/workflows/bump-pinkvault.yml) runs it hourly,
tests the formula on macOS and Linux, and pushes it:

```sh
gh workflow run bump-pinkvault.yml --repo Abyssinia-Labs/homebrew-tap
```

It also links `pink` to `pinkvault`, as latem's formula links `ltm`: a short
name to type. A change to what the formula installs, with no new release, goes
in with `bin/bump-pinkvault --revise`, which raises its `revision` so
`brew upgrade` reinstalls it. When PinkVault's key is rotated, `pinkvault.pub`
changes here before the first release the new key signs (latem-vault's
`docs/release.md`).

### From latem vault

PinkVault was latem vault until 0.7.0, and the formula was `latem-vault`.
The first `bin/bump-pinkvault` run, for 0.7.0, takes out
`Formula/latem-vault.rb` and adds [`formula_renames.json`](formula_renames.json),
which names `pinkvault` as its new name, in the same commit. On a machine with
latem-vault 0.6.0, `brew update` (which `brew upgrade` runs first) moves the
installed keg to `pinkvault`, and `brew upgrade` then installs 0.7.0.
`brew install abyssinia-labs/tap/latem-vault` installs `pinkvault`.

A rename, not an `Aliases/` entry: an alias lets the old name install the new
formula, but Homebrew moves an installed formula only for a rename.

For 0.7, the formula also links `latem-vault` and `openvault`, the names
before it, to `pinkvault`. Run by an old name, it says first, on stderr, that
it is `pinkvault` now. OV-15 takes them out.
