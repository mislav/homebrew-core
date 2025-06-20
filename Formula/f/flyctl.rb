class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.141",
      revision: "5eb9ab31177ec752676a54e402a78d7c47ca7368"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d743f7df4f2bf562fc62a452e38ad2cc9b7ebc8e37f12a59666ee46ee5058358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d743f7df4f2bf562fc62a452e38ad2cc9b7ebc8e37f12a59666ee46ee5058358"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d743f7df4f2bf562fc62a452e38ad2cc9b7ebc8e37f12a59666ee46ee5058358"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa8880fa4fb13ce8f590c93440f7a425dd8079031ebe870d71875f29556ffcbc"
    sha256 cellar: :any_skip_relocation, ventura:       "aa8880fa4fb13ce8f590c93440f7a425dd8079031ebe870d71875f29556ffcbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd5e0954eebebfa3277252114653cdc9d0150245dc07cf6ecbf1c0ddb1766fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a27f362968291a6cbe0b11176c62d19226e3726f15c923c537fd4653f3a3a3d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
