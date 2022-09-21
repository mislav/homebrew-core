class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.16.0.tar.gz"
  sha256 "6f0406b31194bf1ea225442cef651061759ecd82628bb3e60c6c3bc8767b85da"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d73bd2946361ad5b88d519e486c46b6ddf60ad1ec2e3176e51f403a66199aa52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bca5b3a851c3041edcb82b260caa18cd516d6fed19c8203d41a7e4011d18dc8d"
    sha256 cellar: :any_skip_relocation, monterey:       "9e48affcac3f5fbcb78c8de2301cca7d31d80cc6a24a616aa347ab6fbeadbdf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cf8e07e9a32441cac9951ac0209d407daada6a09b6191fecedbc930fd20f9e2"
    sha256 cellar: :any_skip_relocation, catalina:       "65d1390df89e35bcb9be4d264deb94824e5af57fcb5a73675206a669b05e7aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd23b61a033d029ae6b9ea1feafd04fda17b771364e70dbe474c30f05b11ff6d"
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
