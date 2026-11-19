# Written by bin/bump-pinkvault from PinkVault v0.7.0's checksums, signed
# by PinkVault's release key 3AE5705FBEDAB5B2. Change bin/bump-pinkvault, not this file.
class Pinkvault < Formula
  # pinkvault's short name, linked to it.
  SHORT_NAMES = %w[pink].freeze
  # Its names before 0.7.0, latem vault's and OpenVault's, linked to it for
  # one release. Run by one, it says first, on stderr, that it is pinkvault
  # now. OV-15 takes them out.
  OLD_NAMES = %w[latem-vault openvault].freeze

  desc "Encrypted secrets, variables and files synced across your own devices"
  homepage "https://github.com/Abyssinia-Labs/latem-vault"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem-vault/releases/download/v0.7.0/pinkvault_0.7.0_darwin_arm64.tar.gz"
      sha256 "b37a3f2170e74873201937fe918535fcd09347ddac0851d0f0794ab5cbbd8fc5"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem-vault/releases/download/v0.7.0/pinkvault_0.7.0_darwin_amd64.tar.gz"
      sha256 "2143674f521faf86148246e64ffcd16f3753fd992d9198ffbf96482f6887cb63"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem-vault/releases/download/v0.7.0/pinkvault_0.7.0_linux_arm64.tar.gz"
      sha256 "628a01c8e4c0b1a4f7123f547691362afb29c46249a96842011a75b40474a99e"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem-vault/releases/download/v0.7.0/pinkvault_0.7.0_linux_amd64.tar.gz"
      sha256 "8f4afe5da963ac90d7b634a332299caa1adfa1a47dc68930d06502d0c1c5e017"
    end
  end

  def install
    bin.install "pinkvault"
    # Linked here rather than taken from the archive's own links, so the
    # names are this formula's to change. The caveats name them too.
    (SHORT_NAMES + OLD_NAMES).each { |name| bin.install_symlink "pinkvault" => name }
  end

  def caveats
    <<~EOS
      pink is a short name for pinkvault: `pink devices` runs
      `pinkvault devices`. For this release only, latem-vault and openvault
      run it too, after a line on stderr naming pinkvault.

      latem vault is now PinkVault. Update latem to 0.14.0 or later, then run:
        pinkvault service install
      It stops the old service, moves ~/.latem-vault (or ~/.openvault) to
      ~/.pinkvault and starts PinkVault's. A service installed by 0.6.0
      started that version's keg, which this upgrade removed, so it is not
      running until you do. On a Mac, allow pinkvault on the local network
      when macOS asks, or it can't sync.
    EOS
  end

  test do
    assert_match "pinkvault #{version} (", shell_output("#{bin}/pinkvault --version")
    SHORT_NAMES.each do |name|
      assert_match "pinkvault #{version} (", shell_output("#{bin}/#{name} --version")
    end
    OLD_NAMES.each do |name|
      old = shell_output("#{bin}/#{name} --version 2>&1")
      assert_match "`#{name}` is now `pinkvault`", old
      assert_match "pinkvault #{version} (", old
    end
  end
end
