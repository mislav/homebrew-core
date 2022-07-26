class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.14.3.tar.gz"
  sha256 "b674f04ff9954564ba74488fc22817f5548bcddb5d9d582720d2421604988270"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "824d17678869b36a9108793fc20c21658c90f17e95cdae18bb4b17724867a268"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d0dc1c5dd8e5becda2c0b7d3d67dee3080948b0e449888bd9a642441c7c3e3a"
    sha256 cellar: :any_skip_relocation, monterey:       "6e59c340306d0ba2bfdf70e5d8ad78847b731aaf9228ff340941b6f8ddf7bdcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ef157c7f776e0de257e8cc47156d2b0d35d62fb45d8a9f7e931a4dd5db7cc15"
    sha256 cellar: :any_skip_relocation, catalina:       "4d61d4cb33f43d70ce3010f2b7cfc10741aaa7f299da14b8edf3605522d46ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "479070b6afb025a182da7961b1241e20a723a05fcb06cff33b220273d9690790"
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
