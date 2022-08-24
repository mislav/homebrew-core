class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.14.6.tar.gz"
  sha256 "60b0697b9b1db52adabaa804967a6b63f9ffbc634c00940d08861101bc1d5610"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4180215ad9db6976a76d69a2c4e5d848caa7d785035e9b95336caee621dc03f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15ce2c992da6fd273533ad6dcb2544137ab90d688eb78f5896ae9d112df29c35"
    sha256 cellar: :any_skip_relocation, monterey:       "3d1ea14927d6bff0afb87e21273fe7f155dd5ef525e1424b47819e708a94ee16"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddb5555e33b41eb3539ce13986ee6468ab19ba4d3d97d17bdc881e68e1d25d7f"
    sha256 cellar: :any_skip_relocation, catalina:       "1e0bd6a17bc9dcb8160f91b630b78c153e943e0525ef534e9b0b5aabebc4bd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44133e28399a5841c64d4fc83fb72fb4dc72b4a940993fb95be8791c14f0f2b9"
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
