class Moli < Formula
  desc "Headless browser for AI agents, built in Rust"
  homepage "https://github.com/lexmount/moli"
  version "1.1.28"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-apple-darwin.tar.gz"
      sha256 "0e01bc41b797316ba19c4f1b1cbb792f49e7ae03b2e58776f40edb0e62a65fdd"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-apple-darwin.tar.gz"
      sha256 "3a9093ac8c565b65473a325c21a561ca695f2b18fa4cda280358faa486cb9a8b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c2da93301e31851d11c7261e2aed722b63611ea7896ae6838121d112e4228e54"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0d985a1066ec2fd4c456344b867675d9ed68acdf8ccab4001e0a4e9faf672c1"
    end
  end

  # Official agent skills, pinned to the same release tag as the binary.
  resource "skills" do
    url "https://github.com/lexmount/moli/archive/refs/tags/v1.1.28.tar.gz"
    sha256 "c147a2ac8f1c03e10921ee848ba2ad0483dd335d8e247d726c1f3a87b387d44c"
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
