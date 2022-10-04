class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.17.0.tar.gz"
  sha256 "0e8db6dbb148a899db45f4dc8165644f6361d9bd6d088aa7633368b3baedbe54"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b0e772e933a9ee95def41329939e1f98ecf2b28f7f628ebba9cd1846fec4bac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15e40bb41d1602a6cc271bdc95e71e0dcca5604be6e0a3ca2846be723b354eeb"
    sha256 cellar: :any_skip_relocation, monterey:       "78bd2a6f256fc44bad7d79dd85520d38099dc98c72d300c80d30d683452b84c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "56c17a3d05762339c7c4096a53e88c7a783ce07dff71b92f6b84fd3d779c6b67"
    sha256 cellar: :any_skip_relocation, catalina:       "21e4dd3b8569155b8cde7ee89cbdab80ae59d52785302bcda630e2c92f9cadda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c291c65cd0de3484addaf19665e4760b580d9f3a9821b6c6cf054be7b60bc410"
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
