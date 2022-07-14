class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.14.2.tar.gz"
  sha256 "06c78f050127bba298d273f824887ab4544273862abbf109df0e1d4fcb1cd7e6"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f03d9212fbdf3ae2483560a93a1515d1a2e690d83609a3b87349073d63988feb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2edfe34ebd9cc9f558a254e2dae2a9edbde0bf46d0183bbc66b2b6099305ba9e"
    sha256 cellar: :any_skip_relocation, monterey:       "bf018c1c07f14d73afa4e804270780e3809266ce29f1e15ad1f7af6b793b9669"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff6c6586396a3c265795f70d06eaaa17b09f029cd000a44d58dcfa8a9be6832d"
    sha256 cellar: :any_skip_relocation, catalina:       "0e7a40c196cfbf828ea3e7ef2f42c93296f857cd706b4c1ebc0682d19056cc26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1387bb5cfd4ff24704020f20e550f04e66f927c41560de3e1c62c1d523d59068"
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
