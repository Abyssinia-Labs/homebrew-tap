# Written by bin/bump from latem v0.5.0's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.5.0/latem_0.5.0_darwin_arm64.tar.gz"
      sha256 "f75d63f4e44e8c7b9027aa486c295a014200d3f17da1253a5afdf08ffc19242b"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.5.0/latem_0.5.0_darwin_amd64.tar.gz"
      sha256 "4f8495640344ffdc427ee7d49c990df3e75c3cdfc4b9562b061f3b007261b291"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.5.0/latem_0.5.0_linux_arm64.tar.gz"
      sha256 "0bfd05ddf1f76fc93bf4f4578322ad226b2a37b5f045a68a1e80040014ea85b6"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.5.0/latem_0.5.0_linux_amd64.tar.gz"
      sha256 "5cb31023f9f5a76fe1d7390f8d092b0e6a4d757905f53e01fa2b4860bb72cd7a"
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
