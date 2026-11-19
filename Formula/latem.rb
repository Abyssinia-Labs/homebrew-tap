# Written by bin/bump from latem v0.13.0's checksums, signed by latem's
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
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.13.0/latem_0.13.0_darwin_arm64.tar.gz"
      sha256 "ed1f497c9242f43cd583f2435c0cdd22ed3eb2f940a6a772b323aceeb4f020e5"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.13.0/latem_0.13.0_darwin_amd64.tar.gz"
      sha256 "c455333c0f87c6e72e06e6e5dc679a991ad56b4f6deb27d571b06f3d5c5e3a94"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.13.0/latem_0.13.0_linux_arm64.tar.gz"
      sha256 "4cbc0cc0849d35692d6942d51c507291d40febdbeb62aeb0960ab7004428b022"
    end
    on_intel do
      url "https://github.com/Abyssinia-Labs/latem/releases/download/v0.13.0/latem_0.13.0_linux_amd64.tar.gz"
      sha256 "666006d1c99320a06545b75661cffdf58ebd47a7d9433a57a6c9df2591453af2"
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
