class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.11.0.tar.gz"
  sha256 "0b6654a8868363100c4c954377d77a71df04496b2da005f6db1ad765eb44a93f"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb89304795408b3e363dad7dd07093d4da1c978aea188c45ac430cceb95e4ad7"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbac262077e37b83f35ee2f8aef51753d5ff492a43299601d57e7c561b0225c4"
    sha256 cellar: :any_skip_relocation, catalina:      "5eed1faf317654c090a981dd1fe3570965e55c40ca75493e0157c86a69126dfd"
    sha256 cellar: :any_skip_relocation, mojave:        "04ad4d1e6f7785eb8835a8df3b4cba6658904bdbededfd8cd0893e53a6408571"
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
