class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.22.0.tar.gz"
  sha256 "fc9aacccd6a07da6fb2cfa57e2a08d72bdc3a3476f6abec6250cda1e59ae6e16"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "322a53bfd927bbf721bb22cf62d4e92073b0aece1689585215b16572b6581bde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c71ed66837170edad5feaa1b3fba86e8474db81f1cd981340fb7a440f5857a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5c5b24540bb89e184bab2fbda18bd0f8c09639f3e8723bb6b9c1b781859a73b"
    sha256 cellar: :any_skip_relocation, ventura:        "132aa094bcaa5b0a74064b370177c5caa57a38dfcc753813784096e3101831a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c54d7e1b3c55d34eb33f0d8be7d019171033803e26a30631ea1589c4647df23a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b6e09379010159c256b6f3d5a25d7438122885049282aef5533452c55b8ad1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3263b764d8ca85fbb2fc078e5199f365c42349c2a5d4294bec4885bc26ce71b"
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
