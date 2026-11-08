# Written by bin/bump from latem v0.3.1's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.3.1/latem_0.3.1_darwin_arm64.tar.gz"
      sha256 "5cda89156fc3ebcb26a710fbf560b6788ee269853646c4e65c933eb65fa3ac1c"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.3.1/latem_0.3.1_darwin_amd64.tar.gz"
      sha256 "3c656aaf54d862e8ea2a86b13eb15ace945fcb77965c866f4aed91cd1eed0965"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.3.1/latem_0.3.1_linux_arm64.tar.gz"
      sha256 "11308dcca8c68e9b46342859122e04f7f6db4c0a439436e3539e2c9188f5422c"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.3.1/latem_0.3.1_linux_amd64.tar.gz"
      sha256 "3e4027431d667bb0d0bea830e1002a6af6247e6cb80cb7f35c4be7df1866a8b0"
    end
  end

  def install
    bin.install "latem"
    generate_completions_from_executable(bin/"latem", shell_parameter_format: :cobra)
  end

  def caveats
    <<~EOS
      To make this machine a runner:
        latem setup

      The service it installs starts #{opt_bin}/latem, which `brew upgrade`
      keeps current, and the running agent moves onto each new version the
      first moment no build is in flight.
    EOS
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/latem version --short").strip
    # It knows the keg is Homebrew's, and will not write a release into it.
    assert_match "brew upgrade latem", shell_output("#{bin}/latem update 2>&1", 1)
  end
end
