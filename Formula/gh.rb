class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.9.0.tar.gz"
  sha256 "662654baa32550527b97faf38c34254bafe9b7889dc65451cbec3d6dacee2a06"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "833799451ffeea357fa3d82b70effcc168f712e5867beb5e028f819b84ac4e6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "62168fa8a8aee283a4001f9db6f1cd865f61249f41a438e8f98fcce0244b780c"
    sha256 cellar: :any_skip_relocation, catalina:      "a926b6cd06e223cec70c4505c521dbddcd687b3bb1f83563b9ceea25b18fe8a8"
    sha256 cellar: :any_skip_relocation, mojave:        "bf7f43ddfb4c7b73888e0ec7747acf78569567746de7a3b1d1bb03f4adfa32f5"
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
