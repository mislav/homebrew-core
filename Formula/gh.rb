class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.21.1.tar.gz"
  sha256 "7c57f77ce5c8f1f418582b891224cedb364672f397251a1c593b8875f7c34f87"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57c50303c5589e37b75bc35bd94ab12702cce75cc3323ba902e39a8b0663ee82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeebed22a8b042ebdb82c1b46dddb19a3d1b85cef055f676d8dab3618390f08c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a0c23486cdb6c66748ee28a74b87aaed498782d78ebbb8e197e88f74fc08fb2"
    sha256 cellar: :any_skip_relocation, ventura:        "901564caac567454211e718ba90418e5b7bca5685a5ee050c220ee5ddfae3933"
    sha256 cellar: :any_skip_relocation, monterey:       "ecff02041aec83daf6f4defb4be0c558ca1a1c3d8489bd2739e6cd0478a2e198"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c51a3b30e0c5a9044831ff231fbc7d6106d010dcda8627cd756beeeca798227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23150a38a48af9729e9be1b081ce1788619247fb90b22f210cb51e513122f116"
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
