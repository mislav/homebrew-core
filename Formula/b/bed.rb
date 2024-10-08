class Bed < Formula
  desc "Binary editor written in Go"
  homepage "https://github.com/itchyny/bed"
  url "https://github.com/itchyny/bed/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "253284d71fb328d521f4e3db5b94cfa977c196030ca867d6764f99c44370ceb3"
  license "MIT"
  head "https://github.com/itchyny/bed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eb29ee4f9d369143a3177e52c4e6e412e76baec765ecf20f16334f117d5287fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb29ee4f9d369143a3177e52c4e6e412e76baec765ecf20f16334f117d5287fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb29ee4f9d369143a3177e52c4e6e412e76baec765ecf20f16334f117d5287fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb29ee4f9d369143a3177e52c4e6e412e76baec765ecf20f16334f117d5287fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c23fbc4983730757f05f06f6e69250062e291f945efc4433b051a285d2ec342"
    sha256 cellar: :any_skip_relocation, ventura:        "9c23fbc4983730757f05f06f6e69250062e291f945efc4433b051a285d2ec342"
    sha256 cellar: :any_skip_relocation, monterey:       "9c23fbc4983730757f05f06f6e69250062e291f945efc4433b051a285d2ec342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d12893a697b18fcc08cff0db017ddffeb5754f7e514a6d8cdfc3b81665936a22"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.revision=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bed"
  end

  test do
    # bed is a TUI application
    assert_match version.to_s, shell_output("#{bin}/bed -version")
  end
end
