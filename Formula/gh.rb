class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.23.0.tar.gz"
  sha256 "1e9f92a47caa92efedc06b22cfe9c951c5163c4a9bc60a45d477fd5d9b592e54"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e704f932cbc7b237e9143e9db3a9a32f0acd753e03d302299b69d660d3875011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "478754e3d81bb13fe4bb1ca8e87f9ceb0c36ebce3482dadb68a2d23c397a20f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eba00e27abd0c4e8d44c625994750317618ec4b25aba5ed85d7587f097eab754"
    sha256 cellar: :any_skip_relocation, ventura:        "0d4edf27752c509b7173f67dbd24585dcfcda5311993a29e4bc6d963be431b81"
    sha256 cellar: :any_skip_relocation, monterey:       "ee18ef71e646d3f8db5e1aeaeb4aa76adec4a3b9108e6d377f2b98462c3856bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "150ba010f2df6a9b8b4fa47f02c9f23d0a773a2f11582009395cf527e214b432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c9b58d363dd32411f8f0de69887cccd013fbb7bdd76976f0aac21b86316024"
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
