class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.14.0.tar.gz"
  sha256 "1a99050644b4821477aabc7642bbcae8a19b3191e9227cd8078016d78cdd83ac"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d67df1dabd319dd0770f6362aa7a7930f03293c855fb1eaa9f61f5a5e394aa8d"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea76ad7ab1b1920e77ba49d043e98443a538d0280ceed5b25488ee67176e1779"
    sha256 cellar: :any_skip_relocation, catalina:      "779ddf5d46459f56946bc7e7e6066fa7dafb28df26e303dfd24250f34eb8ef3d"
    sha256 cellar: :any_skip_relocation, mojave:        "49ee273c06edbe60dc40b9c331a46d38da9f81ccf591982a01af90dec69cccab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ce6949e3aedf58432c8afb8b21055b57841d6213e83a1c93354190f85dbf2f3"
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
