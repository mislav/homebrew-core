class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/mislav/playground/archive/v1.3.6.tar.gz"
  sha256 "1ee6078b5bcebf21e2f837ea58e8e42b2e1dc910c7d6e8a1c3fcbd9e249a58c2"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1af3676d3d03072ac50e723966c6b5e7ce0353af5dffc630e2a74a31cd66fde8" => :el_capitan
    sha256 "6c867b547061f310896fd7efdac3e48fee470c42706bc449adc3831419381951" => :yosemite
    sha256 "5b454506faf629af5e7f5f95e24e12c2badf374a07617c548c96bec4c71e45fb" => :mavericks
  end

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    system "script/build", "-o", "hub"
    bin.install "hub"
    man1.install Dir["man/*"]

    if build.with? "completions"
      bash_completion.install "etc/hub.bash_completion.sh"
      zsh_completion.install "etc/hub.zsh_completion" => "_hub"
    end
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal "bin/brew", shell_output("#{bin}/hub ls-files -- bin").strip
    end
  end
end
