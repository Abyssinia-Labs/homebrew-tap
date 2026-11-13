# Written by bin/bump from latem v0.8.0's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.8.0/latem_0.8.0_darwin_arm64.tar.gz"
      sha256 "e5e533ac40dbe2e36ccc4bdcf294958a56f9cc756b3337146f5f5ced5c9099e7"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.8.0/latem_0.8.0_darwin_amd64.tar.gz"
      sha256 "aa932c74cdcb167db7e587b92a96a09b20fa8fb5d866a468caa08d233bb5104c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.8.0/latem_0.8.0_linux_arm64.tar.gz"
      sha256 "88bc49b3b18e9afe9a78e0349eb2e5f00a688ec4f4c3178dbce90627c8551d7d"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.8.0/latem_0.8.0_linux_amd64.tar.gz"
      sha256 "afcc521a4c97a89aad9113113ad5e115b303d40b782244fb6c5d0bace1b5d178"
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
