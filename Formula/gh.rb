class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.10.3.tar.gz"
  sha256 "5cb8d367fb028e1ea52f760b03a1239e9b04666dbddc7fd6b1ba3ca9e426a723"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfb5792cf71c39c353665f4e5a17632e951f35739ab19092c305b3ef4fdeb27a"
    sha256 cellar: :any_skip_relocation, big_sur:       "4196fbac342d41cd1c05ab9319f955aed3563eaefd284b4ff141a07aecc9b7d8"
    sha256 cellar: :any_skip_relocation, catalina:      "530926d115eea174d71ea0d4202ee268f16ba606234368e14793d5248ee02b6e"
    sha256 cellar: :any_skip_relocation, mojave:        "e61f675f88dca04269c232d8c6b6ef1c46d62a1f11af06e6fe7b472ec7184e64"
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
