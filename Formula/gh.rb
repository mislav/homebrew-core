class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.24.3.tar.gz"
  sha256 "f5c8a273d3adabee9d4a07d38e738df589f1e9dcdae03f9c7b8e3d8aa4b58cf4"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc40d3bc7f5761bda231b71413134bef529377f5ae5ec0223195ffbc3f20f50c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc40d3bc7f5761bda231b71413134bef529377f5ae5ec0223195ffbc3f20f50c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc40d3bc7f5761bda231b71413134bef529377f5ae5ec0223195ffbc3f20f50c"
    sha256 cellar: :any_skip_relocation, ventura:        "bf15bafadd84f77123c7c75fec35abf265115dee0448ea7661fd3288f98ac151"
    sha256 cellar: :any_skip_relocation, monterey:       "bf15bafadd84f77123c7c75fec35abf265115dee0448ea7661fd3288f98ac151"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf15bafadd84f77123c7c75fec35abf265115dee0448ea7661fd3288f98ac151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dd657b82d0be1c1689a7ff8df09662999b7b5af525f807647092ece736ae229"
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
