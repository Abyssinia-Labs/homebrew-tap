# Written by bin/bump from latem v0.11.0's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.11.0/latem_0.11.0_darwin_arm64.tar.gz"
      sha256 "55839f139fe900e45932f17a449074fe65f84482a4345c5d4118ab6c48917dc9"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.11.0/latem_0.11.0_darwin_amd64.tar.gz"
      sha256 "3fad08fa3b96be83caa51ca1f229d7232ce41168c38395d694c09747956b6019"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.11.0/latem_0.11.0_linux_arm64.tar.gz"
      sha256 "4fc9225c5ea8008fb8e278f600c57d33d0f36ce9978333040f439cdc8f62ebd7"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.11.0/latem_0.11.0_linux_amd64.tar.gz"
      sha256 "500af1d9e602da429b6e8bc9bd98d6c340bb228a1967b273e1eba352db35784c"
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
