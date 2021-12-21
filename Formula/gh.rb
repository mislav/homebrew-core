class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.4.0.tar.gz"
  sha256 "3c87db4d9825a342fc55bd7f27461099dd46291aea4a4a29bb95d3c896403f94"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ba1bb5f5c1cea46850d6d1d83fd9a2a29b0fed5f91180ced232bef419a3f6cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60094c811b0c5c9d308851d631cdde721f371a0161219906a88eb3e3021380fc"
    sha256 cellar: :any_skip_relocation, monterey:       "3fed0152d409d7b603c742a438f285c1e9b9d67650c8e693f4eb74a2e6f397ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "34012b8012d66592d1009062dbab7396419f6d9918e6128fbd4c51535de6761c"
    sha256 cellar: :any_skip_relocation, catalina:       "a747a9d792c76be16ff4c1d2de9caa647f4d17dfcb09fad904ed07f49dcee0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c99ab689fd79a5c1fc84f12437279e05f146e7942a5635e55f8c20962411ce5"
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
