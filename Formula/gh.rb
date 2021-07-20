class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.13.1.tar.gz"
  sha256 "1a19ab2bfdf265b5e2dcba53c3bd0b5a88f36eff4864dcc38865e33388b600c5"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b472c7ad5af1dff481c7cce1e39e97fec16a461a7aa39a8954b58a83387b19f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "70f1f8244e0f3561ea8b9cd9b9219f0cbccf19dc1d4870dcda0398d00ec1efc7"
    sha256 cellar: :any_skip_relocation, catalina:      "3327807e347e47044021d91ce67cee5e6822ba9643859c4567d4e8b2932664fb"
    sha256 cellar: :any_skip_relocation, mojave:        "b4767b1e64d3dc8066b5291a0ef602abd34ddad20b700e75b249f97b9cd89437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ed56cf847c5e6ccdcbbc4b24160f6802e4fbf1867b0defe466b59f2ac8c4db"
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
