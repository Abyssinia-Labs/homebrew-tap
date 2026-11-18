# Written by bin/bump from latem v0.12.0's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.12.0/latem_0.12.0_darwin_arm64.tar.gz"
      sha256 "58f6f004e9a3cd8484037e6c4d78ef852eda9d9f9f56afc33f5bf0f50f9543ff"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.12.0/latem_0.12.0_darwin_amd64.tar.gz"
      sha256 "17028184a6393778f6da3fc35a121445008f9549baa0a3c671d8ea14b8920519"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.12.0/latem_0.12.0_linux_arm64.tar.gz"
      sha256 "5b58e9c8d98796875d94a25f7503a029404ed3d26b550c5c09a24baee77e5298"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.12.0/latem_0.12.0_linux_amd64.tar.gz"
      sha256 "7178af594c35be6c8e40973a6f21618e1792c4b5cbbbb7ed2fdf75f19f3da3d9"
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
