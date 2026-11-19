# Written by bin/bump from latem v0.14.0's checksums, signed by latem's
# release key D73938C642AD64D3. Change bin/bump, not this file.
class Latem < Formula
  desc "Self-hosted CI runner with first-class mobile builds"
  homepage "https://latem.dev"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.14.0/latem_0.14.0_darwin_arm64.tar.gz"
      sha256 "1e8498d27036559e75c4153ff45b85d66dc7cd1dfb54da4c026df0b7130dd567"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.14.0/latem_0.14.0_darwin_amd64.tar.gz"
      sha256 "8386f9ab9cd45e386b4333145bfb8805d384d840fac1f1d57cce63046b6a7b91"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.14.0/latem_0.14.0_linux_arm64.tar.gz"
      sha256 "2848b4a074c5622f02e960c0373cb0f9792de27b8d1f9d70fbc14a588362bede"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.14.0/latem_0.14.0_linux_amd64.tar.gz"
      sha256 "8f8797d74dcd22c2139b66a47f8d8a610405b6bf1c9caba0ba0bcd2c748b185b"
    end
  end

  def install
    bin.install "latem"
    # latem's short name: the same binary, by a link beside it.
    bin.install_symlink "latem" => "ltm"
    generate_completions_from_executable(bin/"latem", shell_parameter_format: :cobra)
    generate_completions_from_executable(bin/"ltm", shell_parameter_format: :cobra)
  end

  def caveats
    <<~EOS
      To make this machine a runner:
        latem setup
      (ltm is latem's short name: `ltm setup` is the same command.)

      The service it installs starts #{opt_bin}/latem, which `brew upgrade`
      keeps current, and the running agent moves onto each new version the
      first moment no build is in flight.
    EOS
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/latem version --short").strip
    assert_equal "v#{version}", shell_output("#{bin}/ltm version --short").strip
    # It knows the keg is Homebrew's, and will not write a release into it.
    assert_match "brew upgrade latem", shell_output("#{bin}/latem update 2>&1", 1)
  end
end
