# Written by bin/bump from latem v0.4.1's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.4.1/latem_0.4.1_darwin_arm64.tar.gz"
      sha256 "c869adfea37a4a925954d83d1c708ef834ecd7fd7f698c4fdf76f98a58f624a5"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.4.1/latem_0.4.1_darwin_amd64.tar.gz"
      sha256 "122088ed3a2e2601d95748295ee05317cd6bc19fabccdd0c1857ee4546371e19"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.4.1/latem_0.4.1_linux_arm64.tar.gz"
      sha256 "49630f72af4bf6494ee038cfa01719f43fc764fe6c54ea7fda4950bd611b30cb"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.4.1/latem_0.4.1_linux_amd64.tar.gz"
      sha256 "2a325e7bd76e2e4092e2e44f22bb7aa8609691a98dc6b51e42f763aba9dadc18"
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
