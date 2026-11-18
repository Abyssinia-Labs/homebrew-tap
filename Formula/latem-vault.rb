# Written by bin/bump-latem-vault from latem vault v0.6.0's checksums, signed
# by latem vault's release key 3AE5705FBEDAB5B2. Change bin/bump-latem-vault, not this file.
class LatemVault < Formula
  # latem-vault's short names, linked to it.
  SHORT_NAMES = %w[vault lv].freeze

  desc "Encrypted secrets, variables and files synced across your own devices"
  homepage "https://github.com/Abyssinia-Labs/latem-vault"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem-vault/releases/download/v0.6.0/latem-vault_0.6.0_darwin_arm64.tar.gz"
      sha256 "65026456f40b166c6e76ceaeccaf01612bbafa502e6891e48fb151c2bf6985ae"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem-vault/releases/download/v0.6.0/latem-vault_0.6.0_darwin_amd64.tar.gz"
      sha256 "c367402443ecded694e2b60c49a0bf55403cf53b478d8117e0cc1ecbca92208c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem-vault/releases/download/v0.6.0/latem-vault_0.6.0_linux_arm64.tar.gz"
      sha256 "a8c6df6438ab7eca275681b32aac32eabd986e9a1cb5da009637811e98c28940"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem-vault/releases/download/v0.6.0/latem-vault_0.6.0_linux_amd64.tar.gz"
      sha256 "a3d837e8bb9c8ce7d9af5536652bcbd7c5ad901bbb985453049cb37088d59d3d"
    end
  end

  def install
    bin.install "latem-vault"
    # Short names, as latem has ltm. The binary keeps its name: latem looks
    # it up as latem-vault. The caveats name them too.
    SHORT_NAMES.each { |name| bin.install_symlink "latem-vault" => name }
    # OpenVault's old command, for scripts that still call it: it says the
    # new name, then runs it. For the release that renamed it only; OV-15
    # takes it out.
    (bin/"openvault").write <<~SH
      #!/bin/sh
      echo "openvault is now latem-vault: run latem-vault instead." >&2
      exec "#{opt_bin}/latem-vault" "$@"
    SH
    chmod 0755, bin/"openvault"
  end

  def caveats
    <<~EOS
      vault and lv are short names for latem-vault: `lv devices` runs
      `latem-vault devices`.
      HashiCorp Vault has a vault command too. Where both are on PATH, lv is
      always latem vault; Homebrew won't link both formulae.

      OpenVault is now latem vault. To move a vault from ~/.openvault to
      ~/.latem-vault, update latem to 0.12.0 or later, then run:
        latem-vault service install
    EOS
  end

  test do
    assert_match "latem-vault #{version} (", shell_output("#{bin}/latem-vault --version")
    SHORT_NAMES.each do |name|
      assert_match "latem-vault #{version} (", shell_output("#{bin}/#{name} --version")
    end
    old = shell_output("#{bin}/openvault --version 2>&1")
    assert_match "openvault is now latem-vault", old
    assert_match "latem-vault #{version} (", old
  end
end
