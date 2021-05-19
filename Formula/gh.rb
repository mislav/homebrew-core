class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.10.1.tar.gz"
  sha256 "c64c26508ccb8e8c2876b3c3bf7fe0b121d787645b2142774c7389dc3035a8e3"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3dc9e029c1a272b6cf303f27ebfea809dfaddb20ff5d92d2b1f0235fcdec6433"
    sha256 cellar: :any_skip_relocation, big_sur:       "25ece792d530b2aed330a91927dc88b50a1f79ba78e30390f65280261571b204"
    sha256 cellar: :any_skip_relocation, catalina:      "bad77b0b7923229bab37f29830aa44b5c5da0c379e3808dc6eafbb452fe1454f"
    sha256 cellar: :any_skip_relocation, mojave:        "eca9a55868584824b1962ab4b15f69b336ce8d4138ab2599a249f73b3b9d8abb"
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
