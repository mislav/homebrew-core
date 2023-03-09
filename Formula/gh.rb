class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.24.2.tar.gz"
  sha256 "d5a7f24b128a1dcd430f1a281099378eee504a2ba712deaf22880b7815d96671"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d83a2a2a12502aa48c66ad5b477d8290afd54b694cd5ded96bb521d822a75126"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d83a2a2a12502aa48c66ad5b477d8290afd54b694cd5ded96bb521d822a75126"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d83a2a2a12502aa48c66ad5b477d8290afd54b694cd5ded96bb521d822a75126"
    sha256 cellar: :any_skip_relocation, ventura:        "584b6fc0161ad5c6beceaf74ca24ad1f17ab26f36fafd93e01de5b7baa425dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "584b6fc0161ad5c6beceaf74ca24ad1f17ab26f36fafd93e01de5b7baa425dc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "584b6fc0161ad5c6beceaf74ca24ad1f17ab26f36fafd93e01de5b7baa425dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d166647e4766a710cf67888b28f21ccd719d5757416b39133fd443dc8fc2ef5"
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
