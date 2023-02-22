class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20230222.tar.gz"
  sha256 "22793d0a46d0c85dc4b26eda53ffeb09bd26d16cd1269fd2544abcab061db619"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "949900a35df43a7aacab78bf973a6a5da38aee4e21e2d0e9180f52487f65dad5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "560dea6e6df04bcc55fd7f4dde5bd6dd3529bbe325cf534c43a066165cc0c889"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "059e85d4e66bfd4d85e46ab86ce0fbf2bc832d015aa081855f35e073001cb4e1"
    sha256 cellar: :any_skip_relocation, ventura:        "4163f52bae37a6dd9656b6e48e7b69222fd7900671700ed0b89a18ea7f192af7"
    sha256 cellar: :any_skip_relocation, monterey:       "3b7a88cb0c352dcd6d9824ac5265e299fad5e4737e22da0b69bfc462647abca1"
    sha256 cellar: :any_skip_relocation, big_sur:        "37e968fad896c0fef4b608457207f0b6ee670cd16ba89c0519692fce9ecfd047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02416bdee3d58c3de48184676847fdb7c4356332c1a6b3df752c361798783921"
  end

  depends_on "autoconf"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    # these references are (as-of v20210420) only relevant on FreeBSD but they
    # prevent having identical bottles between platforms so let's fix that.
    inreplace "bin/ruby-build", "/usr/local", HOMEBREW_PREFIX

    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  def caveats
    <<~EOS
      ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and these are never upgraded.

      To link Rubies to Homebrew's OpenSSL 1.1 (which is upgraded) add the following
      to your #{shell_profile}:
        export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

      Note: this may interfere with building old versions of Ruby (e.g <2.4) that use
      OpenSSL <1.1.
    EOS
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
