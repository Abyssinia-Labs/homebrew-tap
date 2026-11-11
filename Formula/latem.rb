# Written by bin/bump from latem v0.7.0's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.7.0/latem_0.7.0_darwin_arm64.tar.gz"
      sha256 "89cc0204465db97f473173fe78a8f10d1ef0a133ff21e6729e596f810571bec7"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.7.0/latem_0.7.0_darwin_amd64.tar.gz"
      sha256 "87ba54d8f2b66defc54021ae98ff8c96fdbdf27f68f9b84c4bfa498631b7ccb2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.7.0/latem_0.7.0_linux_arm64.tar.gz"
      sha256 "233ac7eae9ff7c6124c27df7cf9171f0dc90ba1b01cc4f89d7512cb0b62674cf"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.7.0/latem_0.7.0_linux_amd64.tar.gz"
      sha256 "755ae7158ddc9d6bd915c92a58efa3df9b725ab3ff24d55f5b99bbec87f8b6cf"
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
