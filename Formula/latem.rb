# Written by bin/bump from latem v0.4.0's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.4.0/latem_0.4.0_darwin_arm64.tar.gz"
      sha256 "b736fe6881c2bb6f04631a1bff1bc6bd7c751f468b144b2d4a8d501554af57a9"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.4.0/latem_0.4.0_darwin_amd64.tar.gz"
      sha256 "1b0a0409b9f7d593d55279903d35c60b5bfd2e74f1860a2aaea8167b68d3978b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.4.0/latem_0.4.0_linux_arm64.tar.gz"
      sha256 "05daa19eb16f298b3ce8d05e71929bef5ab43a2d4a78244149973712190bd5aa"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.4.0/latem_0.4.0_linux_amd64.tar.gz"
      sha256 "888490dca267ec369f0241d20b10cfc5775ee6ed91621724d34f40c6dfeca0f4"
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
