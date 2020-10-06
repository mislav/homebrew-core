class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.1.0.tar.gz"
  sha256 "3340bcec77dd9cbb5074399effc876cb7d759a235d24ea11253ad7b232b620a2"
  license "MIT"

  livecheck do
    url "https://github.com/cli/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "77b42bd6b610134ee3b407304a816ddbbcb03a38b527dbd00c25df74a3623606" => :catalina
    sha256 "5dcd8c6293d3ab2382b8b8e7334b9c76c0b6ba7f72dd6f04338016a2ba478120" => :mojave
    sha256 "5172276658f9f8902d5684861892088e153e26eb4ed3f7565e2592855e38d69f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GH_VERSION"] = version.to_s
    ENV["GO_LDFLAGS"] = "-s -w"
    system "make", "bin/gh", "manpages"
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
