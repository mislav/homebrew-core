class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.21.2.tar.gz"
  sha256 "225cdeeaf7cacd837abd58ec1b29a5351de02509d82a70921842214ebf2389be"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a65c963638f4cbdc86566b15eb0327b753c78216e06937a2c1442f451c1799ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c771a160f354859b0868c1cf11cd3559e04cc23fc1e3fd45c852712258543828"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86e0fa9b8c1594436746f5e8b68e93c6a0dc5510ca63fc69232e96cc87f9dc0f"
    sha256 cellar: :any_skip_relocation, ventura:        "d54bad49e982d6c1b47ad9a17317f5b8c3fb64209b235a0c0239fa3da4a402e6"
    sha256 cellar: :any_skip_relocation, monterey:       "0d933fb1531bf439d13d1a7a2d47a2a0ac67b46fb163638c4b2c71d75a9cd868"
    sha256 cellar: :any_skip_relocation, big_sur:        "09c2b7ba64796b4f86722b9e891baa72c2981da4da9e73aef481e244ddf73704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff449c4975b1ff2a117a3d63f7f13aa660055d4c6edb1aaa782e2be1f4228d0"
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
