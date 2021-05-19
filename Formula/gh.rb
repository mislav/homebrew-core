class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.10.2.tar.gz"
  sha256 "4989561a2bd13e34a109497503c3552d06155637248fa3123e760fb696421d8b"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44ff331c4365a129f11f2780ab8561b0c24a8a20aa71b71ff76f4c8f672ea233"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7c99af7768653824014935fa3605f08701f7d5050f8057c534b498273c8863f"
    sha256 cellar: :any_skip_relocation, catalina:      "8cd3e8d74a9f2f96128657f3c4411628b5b14385d6ae4e63e6c060e54c9d5770"
    sha256 cellar: :any_skip_relocation, mojave:        "da2c76326b9b5ab3d2bb338afd17abac559eb1c6fb4b7261e0bc0cf468a3b889"
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
