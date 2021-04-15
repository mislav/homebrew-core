class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.9.1.tar.gz"
  sha256 "5fd35b156a0528ad4e8b68c7058fccf340cca08b0cabd36d872ab855476fb02e"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89cd7b6e00f3859a9d47383005657d32e89f866713bd618b7d486857bbc481bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f6bed519a278d2abcdb12ea043dc06c27f827f291b7863acf477efcab239598"
    sha256 cellar: :any_skip_relocation, catalina:      "1da9375f4cc7da372b5723f2e46f20a95c2d427bbdb2d03ce2b4a556f1448ff0"
    sha256 cellar: :any_skip_relocation, mojave:        "58cfa311ba3198219be8b184ff075bf8e81a8c578b910caf7dce562a83ea876a"
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
