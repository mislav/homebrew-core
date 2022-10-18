class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.18.0.tar.gz"
  sha256 "313eaf102339535fb73cbb3f2cbe7bddce96e5323f32129592a48536cce950a3"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1f937661f1a960dd69d5e4048182cb80b9362001a06e297cea22f794c92ab63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "182819aa2db495f5afd830e67185115aeceb4a678764ead6f5d406ee1657613a"
    sha256 cellar: :any_skip_relocation, monterey:       "48a60965e9b8799023e82744c1d9a23d79107c4c7453e6dfd7919ceb9eede192"
    sha256 cellar: :any_skip_relocation, big_sur:        "2968514d2b9b205b1d74f5eba7857be3e33bcd5d9b6513ad4c0418b1d7e67f4e"
    sha256 cellar: :any_skip_relocation, catalina:       "c0c89cf886cf26aff58b4182e685dfc4b60c93a664f382e242cdbacf61bb94f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89029324cb509321864d4a2a9277ec483217754762d2528f71b2a749c67fdc18"
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
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
