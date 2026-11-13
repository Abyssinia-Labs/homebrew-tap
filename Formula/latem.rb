# Written by bin/bump from latem v0.10.0's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.10.0/latem_0.10.0_darwin_arm64.tar.gz"
      sha256 "61788f03847b33d588615c5d946b02390b3e673dd70c4e7714babdee43589bf4"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.10.0/latem_0.10.0_darwin_amd64.tar.gz"
      sha256 "065543167b616a7bfd60772c757ee9cb83ef9602bc440abc0a7b6d1979aca47f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.10.0/latem_0.10.0_linux_arm64.tar.gz"
      sha256 "530786ebf40839da6dc42804a5d7d7b7599efe2f463ff2b008ec31277162ac37"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.10.0/latem_0.10.0_linux_amd64.tar.gz"
      sha256 "2045178d0b4b35bfc2ea5274a1bb9fa3ff8c63248ffb70e40c71c917d3b324d4"
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
