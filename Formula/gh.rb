class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.8.1.tar.gz"
  sha256 "5bdbc589a6d5cca241b2dc467d846a8f23c465d78efd898271f18b636608d6e6"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "70f3efb480ed39dbcbb135dc50357d683409ffa0136b711da3725c0ea365a619"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2c1698ed62087998541b45b4758f0bb6c025be2ccef3d7b5df008aa29ea5587"
    sha256 cellar: :any_skip_relocation, catalina:      "7744996aa942cde9f3585a1ea322cacde82f123cd8d484d14948665c55845d07"
    sha256 cellar: :any_skip_relocation, mojave:        "8fcab6998821e19696c0c27670b7a1873c9bd6a2220a8668f25df05e112feb50"
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
