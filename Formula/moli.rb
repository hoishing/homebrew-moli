class Moli < Formula
  desc "Headless browser for AI agents, built in Rust"
  homepage "https://github.com/lexmount/moli"
  version "1.1.27"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-apple-darwin.tar.gz"
      sha256 "0a9334ad9c52fb79e2995e61ed35737839cd3a0a7b54c4292a1f413014d338df"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-apple-darwin.tar.gz"
      sha256 "8a2fc8540b30e244c71142086855886fea2ba96eb67ab4a4c11ce8f1bb52fb0d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f33ce375155f36beea672f9f45785a09ab8913c69955b166c7a479712b8456ad"
    end
    on_intel do
      url "https://github.com/lexmount/moli/releases/download/v#{version}/moli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2ede138ca107f16313183be06ef137c0760eaeb83598570d7f4a4263595cd1a6"
    end
  end

  # Official agent skills, pinned to the same release tag as the binary.
  resource "skills" do
    url "https://github.com/lexmount/moli/archive/refs/tags/v1.1.27.tar.gz"
    sha256 "cf394871fe994ef827d2982daed2c141cc159eb471c4b80fb2fa544e6304b4df"
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
