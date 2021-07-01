class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.12.1.tar.gz"
  sha256 "14ef58fb2f09da1d66194527e1e8b637d28d972d273a6a627056aa960a9a9121"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6f07c2770d85a62fadb9c4141425da0d4eef2cb48cb33fe83367e078e13a2fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "0091aa6dc86e87275a86c5c54b3620ab316feaa550858098e1b27c529a68a206"
    sha256 cellar: :any_skip_relocation, catalina:      "fd975d572bdbf5f4062dc4eb442179aa1a61e8abc346a4ff3a7634f773a563fa"
    sha256 cellar: :any_skip_relocation, mojave:        "4fbe6b0ac3a3e6ea39c0df17f7476e8804b05c795791d4aa35448f73b5b46ab0"
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
