class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.14.7.tar.gz"
  sha256 "a1a048714d7c7b237ea05f1fb51b3f3f4cdf90a16c60fa46f1df2eb5d96ce28d"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dcd616f5f4089aa41e296c414fd4c22a28ccaddb86176e33881fe6707eefdcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21c71c7815502500bfedfee03aba50dace10419467e08d95374c6ff207d808ac"
    sha256 cellar: :any_skip_relocation, monterey:       "00f4be15f1582babd09579612aca91d1388fb4e81722102b7289822f920d8e19"
    sha256 cellar: :any_skip_relocation, big_sur:        "d98adcae17f0402287909be4af3f4721d1ada935d5bd162e96f5826c066c85f8"
    sha256 cellar: :any_skip_relocation, catalina:       "eb522158bfb9438110e3e2cb3157f1f659c4a44175224a2e6defbf52dbb65f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e13c8ac1fb1a54e1f492b4a9c97a9969e5c8c237d34ffe8cfc30590007e133"
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
