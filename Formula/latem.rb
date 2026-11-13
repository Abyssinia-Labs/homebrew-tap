# Written by bin/bump from latem v0.9.1's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.9.1/latem_0.9.1_darwin_arm64.tar.gz"
      sha256 "9d47819cf561642b071c9f69b56ae3dfed6828d7413e54fc90ebe04f3dbb043a"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.9.1/latem_0.9.1_darwin_amd64.tar.gz"
      sha256 "2331ee378fabe9ec7855f9491bd6e11c7ddfd1e5b4d10287ae06b052ceaf38b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.9.1/latem_0.9.1_linux_arm64.tar.gz"
      sha256 "62d19fc0ad431856d4dae14c0bc28afc6d331685e3a602251a2fcfa309437799"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.9.1/latem_0.9.1_linux_amd64.tar.gz"
      sha256 "7f0536c2739a2f544ec151c75023b1cc65da9df7aaaa779ca111ac7141c58ea2"
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
