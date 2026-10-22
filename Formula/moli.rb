class Moli < Formula
  desc "Headless browser for AI agents, built in Rust"
  homepage "https://github.com/lexmount/moli"
  version "1.1.19"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-apple-darwin.tar.gz"
      sha256 "65f389b4e9f71eb9bf2d879984bb1a599d9c09b171513bd2b9af3950e0fb15be"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-apple-darwin.tar.gz"
      sha256 "553a76b18ebae849cdf9895ce991231b89d0405fd6de7157a92ffa72dd14a48e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f3c71ff43d250fdc16fbf74a34f7c0041b47f8ba25bba1cb476bc88db587bfc8"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5c22362065e64e6de785274f6b3f28a735fca363abf9896c48733e5f58489def"
    end
  end

  # Official agent skills, pinned to the same release tag as the binary.
  resource "skills" do
    url "https://github.com/lexmount/moli/archive/refs/tags/v1.1.19.tar.gz"
    sha256 "3e6bbacbf3ce9e9b4634129912bc513ae70c064974c94e0111f068aff2475924"
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
