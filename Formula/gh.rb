class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.16.1.tar.gz"
  sha256 "ed42d919d22b33c60d7c4243ac37cc1127e342817e563038aeba2e2a3f93ed81"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ceab857dc0242686140762ec00a7777afd637d8fc2785235850f99147252dc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c70aea632c7c1673c5d5764403da2d46fd4ed19d7bcd68d89e50a48b9f3d862"
    sha256 cellar: :any_skip_relocation, monterey:       "4a1835b2f060354b57201a795bbe3e401fa468a153fe70b95196bcabaeec692f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8b9b2ccd780335f6b6fd0d2274d98150c660c9b7d08db4b88ffed744ecd80ae"
    sha256 cellar: :any_skip_relocation, catalina:       "96c62acd1755daaabcb38470e4c727add2fc72f818c1639348330bfd155075f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82a33be720c254b43dcfa4390fffc2179ebecf3eea51ebc4b479e95ca0bc5487"
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
