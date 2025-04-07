class Ucon64 < Formula
  desc "ROM backup tool and emulator's Swiss Army knife program"
  homepage "https://ucon64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ucon64/ucon64/ucon64-2.2.2/ucon64-2.2.2-src.tar.gz"
  sha256 "e100ad4a30f6c19abde98e361c6a0ecac4e40477f54cfb75498c5ccd21fb3a18"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/ucon64/svn/trunk/ucon64"

  livecheck do
    url :stable
    regex(%r{url=.*?/ucon64[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "f55e08ec43d072e3a5e53d38a3244adae7dcaceca71045c2bd525f05a1588609"
    sha256 arm64_sonoma:   "301ce960dee0312e69f72b00da7d4e297091039cfe5e3d10364fe48fb0b49122"
    sha256 arm64_ventura:  "228557d22fcc52015a45e5e22d4e8b9d6a9997600e5ad4127afd39d2bdbd7dd0"
    sha256 arm64_monterey: "516c8d6bcfbc9101c237e9ec08d13b11f9e0347d1fa5841f670cb8945a93b665"
    sha256 arm64_big_sur:  "ca76694128cae76b0f5f177d3ab2106a7e955caf7480be607368e8507cf0ab75"
    sha256 sonoma:         "92e61d689784b5efd81c592b19479e8daea813005c712443ccff002ce2c6e504"
    sha256 ventura:        "9e2d7117710cb6f8084dcbc36ecf0c607c1de1d31923df54224cf6f21f8b86ba"
    sha256 monterey:       "1ffac20e4aafeabe33ab750f2f40589bb894caf7ee372380a065abeb7e06655c"
    sha256 big_sur:        "1638a10fb2622983abc00934ba023cb03a1d7b332e45d9024b717f74a0d3fee7"
    sha256 catalina:       "3672dbe3c97e6d71f22a6666adec1cca709ffc3dea9c76baf16fbeb8f63a4782"
    sha256 arm64_linux:    "15cef90fe66dfeaa08768ef3a8c3640ae30454fbd7e682b05357b7bc95be9fb3"
    sha256 x86_64_linux:   "f2b2e0353e5bfa4e226a5182b6d36786874ced3c0ae4426866d2a2436aa0c739"
  end

  uses_from_macos "unzip" => [:build, :test]
  uses_from_macos "zlib"

  resource "homebrew-super_bat_puncher_demo" do
    url "http://morphcat.de/superbatpuncher/Super%20Bat%20Puncher%20Demo.zip"
    sha256 "d74cb3ba11a4ef5d0f8d224325958ca1203b0d8bb4a7a79867e412d987f0b846"
  end

  def install
    # ucon64's normal install process installs the discmage library in
    # the user's home folder. We want to store it inside the prefix, so
    # we have to change the default value of ~/.ucon64rc to point to it.
    # .ucon64rc is generated by the binary, so we adjust the default that
    # is set when no .ucon64rc exists.
    inreplace "src/ucon64_misc.c", "PROPERTY_MODE_DIR (\"ucon64\") \"#{shared_library("discmage")}\"",
                                   "\"#{opt_prefix}/libexec/#{shared_library("libdiscmage")}\""

    cd "src" do
      args = ["--disable-silent-rules", "--with-libdiscmage"]
      args << "--disable-parallel" if OS.linux? && Hardware::CPU.arm? # no sys/io.h
      system "./configure", *args, *std_configure_args
      system "make"
      bin.install "ucon64"
      libexec.install "libdiscmage/#{shared_library("discmage")}" => shared_library("libdiscmage")
    end
  end

  def caveats
    <<~EOS
      You can copy/move your DAT file collection to $HOME/.ucon64/dat
      Be sure to check $HOME/.ucon64rc for configuration after running uCON64
      for the first time.
    EOS
  end

  test do
    resource("homebrew-super_bat_puncher_demo").stage testpath

    assert_match "00000000  4e 45 53 1a  08 00 11 00  00 00 00 00  00 00 00 00",
                 shell_output("#{bin}/ucon64 \"#{testpath}/Super Bat Puncher Demo.nes\"")
  end
end
