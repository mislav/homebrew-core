class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.11.3.tar.gz"
  sha256 "1a4a90b1893dac022c1cfb298ebb52f66a8f93b353eafcf7bbfb43c8c0b46dfa"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bbb2c2c0110995f4a459ac509b1fccdba13969052efbe9d91cbdefbfbc8d945"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2367943b0f7d885a9f3db1e52ab6c1b7215864495a0dee74d7155a86254c4bbf"
    sha256 cellar: :any_skip_relocation, monterey:       "333041fa880c5d0b96a958aa88c31fded6abe422d63c030ed82384cb16c9790f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef1f179fa4427423103fa62f9bd0d947b6d28241a876ab8241829254c95180ff"
    sha256 cellar: :any_skip_relocation, catalina:       "0e1848fa2d046224411b54d2d7481d1c1484afe43695a7bc47079b6e09d1053e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5659ed5d39ec9d5a64d8b9c58ec4851c0dc7774471d76a0e93b9acf4bac24fc2"
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
