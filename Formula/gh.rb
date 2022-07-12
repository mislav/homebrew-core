class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.14.1.tar.gz"
  sha256 "83ea9ae83c7de8f5cf73ee33004e655cbea5665165740511abfda8c0e489f7fa"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec750c1f85c3973a4b5ac2d40db64a13a8aec9306fb81ece9ebd61086dd1d650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc1ed8c08eaed3fda6e135851f076de0904f6959096630c31eba27688fdd074a"
    sha256 cellar: :any_skip_relocation, monterey:       "acd2f7b12e8eecd29d1e5acec9577624dfa0fb91ae4f30b309e6b38479164eb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd51ae72543556c5d2cf4d622268346aa3fcc74a9e6bd0a2141c4e47b3b4228"
    sha256 cellar: :any_skip_relocation, catalina:       "bbf28bde73e3d795377ab8acbb09e156d82aa507ae6da3489360085def6f4d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37dc253e3d878990847fb2f4c4cbc9cd34d86002327db7622425cda4030d89ea"
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
