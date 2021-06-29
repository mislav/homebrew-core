class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.12.0.tar.gz"
  sha256 "e0a3f1d4bc9e2561e080314dfbff294602e782c16fcfb17e5b9f67f89a1c145a"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb781be3dd6600c0a437cb96e1ffeedbd75e01ca7471930a0730e3cbee97e59b"
    sha256 cellar: :any_skip_relocation, big_sur:       "34313bfaca6995d40836da15f3c1cf7579689f5ac1bdcf3e2e4e50ceb4cbb3e1"
    sha256 cellar: :any_skip_relocation, catalina:      "a2fac7d8afcc6176bd06c4151c537e4f6a482c56635c2740d7be7033fcfb4157"
    sha256 cellar: :any_skip_relocation, mojave:        "5fbddd4c9fe6beacceb4ed4348b41599c9c2249e0bf23b32d23c51303d4ff46d"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
