class Moli < Formula
  desc "Headless browser for AI agents, built in Rust"
  homepage "https://github.com/lexmount/moli"
  version "1.1.25"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-apple-darwin.tar.gz"
      sha256 "2eee47d5a82920529f56aef9138aa1e3b0f9ae2dde96080e7ff128110081cf0e"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-apple-darwin.tar.gz"
      sha256 "5789fb0e2ddce8aa92ce82681e6d889df81ad8bf5597628d404659621225ec74"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "95c094a0214431193ee93142dec91cc7affbea79e9b35094213b8b9230ccd134"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "04c73204626054c9ec0064f7fc00abb0dcfa7f8b9c3ec9df5de8e2afc301087f"
    end
  end

  # Official agent skills, pinned to the same release tag as the binary.
  resource "skills" do
    url "https://github.com/lexmount/moli/archive/refs/tags/v1.1.25.tar.gz"
    sha256 "c8384b08432dbad5986e845d68b3a4e43dcdee4b25b4bdcd597949969fe758dc"
  end

  def install
    bin.install "moli"
    resource("skills").stage { pkgshare.install "skills" }
  end

  def caveats
    <<~EOS
      Agent skills are installed to:
        #{opt_pkgshare}/skills
      Symlink them into your agent skills directory, e.g.:
        for s in #{opt_pkgshare}/skills/*; do ln -sfn "$s" ~/.agents/skills/; done
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moli --version")
    assert_path_exists pkgshare/"skills/moli-webfetch/SKILL.md"
  end
end
