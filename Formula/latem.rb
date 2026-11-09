# Written by bin/bump from latem v0.6.0's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.6.0/latem_0.6.0_darwin_arm64.tar.gz"
      sha256 "4a135b4a0768e7a89b113c45621dadf2288c0e7ccd6be4f4055be4930806fc76"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.6.0/latem_0.6.0_darwin_amd64.tar.gz"
      sha256 "f3f3f86bd2a9c82978a87c9d93f57a787faab7cffb790797ef0676e6e76a2331"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.6.0/latem_0.6.0_linux_arm64.tar.gz"
      sha256 "f2033dbe6a0ad601a366bc44d57a337149ca979d142c9ccae0828b04a137c60e"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.6.0/latem_0.6.0_linux_amd64.tar.gz"
      sha256 "82a45510dcd77da497ba0cae7dcad7798a0192a55173eccdfd4f28db130deba0"
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
