class Moli < Formula
  desc "Headless browser for AI agents, built in Rust"
  homepage "https://github.com/lexmount/moli"
  version "1.1.18"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-apple-darwin.tar.gz"
      sha256 "68b2f0d42f018d6c00bf9ab222481b12a8e8ba161050645b9151557c4b6d362f"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-apple-darwin.tar.gz"
      sha256 "c94e46b2c30671e2732410c88ac3aceab02dc590c3b690901d3963e40a08a293"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ec57982984245811e2e9ea59a7b45693c01c38ccf403bbe2ea2b1b3bebd482fb"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "59715fbdb2b016bb9136e1edb59a2a195c0f98459fd06739e17edc62da6a48b1"
    end
  end

  # Official agent skills, pinned to the same release tag as the binary.
  resource "skills" do
    url "https://github.com/lexmount/moli/archive/refs/tags/v1.1.18.tar.gz"
    sha256 "d150d3ae79b1fc492a39af6832b3a44baeaaacc045384d16a76d5860599c9106"
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
