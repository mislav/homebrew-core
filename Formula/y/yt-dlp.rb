class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audio/video downloader"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/7d/3f/c63b11419d7adacde35b39e7e62aef1be6ce9ff3d2219fae024962ab4a53/yt_dlp-2024.9.27.tar.gz"
  sha256 "86605542e17e2e23ad23145b637ec308133762a15a5dedac4ae50b7973237026"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fcd1b21e0710ceea8f1e09cb273993d6822eff9fd06d1c06f91b245f53595950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b797b9c734c968900c690934f542cd13b8e33dd2f8b9d97413511008495542c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a785f580e0075cff2b1c52cc3b468be99ef38114744d0684e83af000d3f9fcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd7cf194bec80d202936154aa558384660917741dd69cb374b157d30867a5f8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4cdbd90d33c45a57ab7f1613db0f8f06a652ba8d1b37796f85d6d4607cf9b14"
    sha256 cellar: :any_skip_relocation, ventura:        "017176aa114602671f31ae0c3b549f63fd7c5ee0e6e01574a85b468f039820b7"
    sha256 cellar: :any_skip_relocation, monterey:       "fc342e130a8e9eb8bc64da6db261821c3edba7d2e7f9aecfaeead86caa8c7569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "856e6287992355951c8b5981c142928465b9414d5bf68f64789d8db9a32bfb13"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

    depends_on "pandoc" => :build

    on_macos do
      depends_on "make" => :build
    end
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/31/a4/b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1/pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/e2/73/9223dbc7be3dcaf2a7bbf756c351ec8da04b1fa573edaf545b95f6b0c7fd/websockets-13.1.tar.gz"
    sha256 "a3b3366087c1bc0a2795111edcadddb8b3b59509d5db5d7ea3fdd69f954a8878"
  end

  def install
    system "gmake", "lazy-extractors", "pypi-files" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1"
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    system bin/"yt-dlp", "https://raw.githubusercontent.com/Homebrew/brew/refs/heads/master/Library/Homebrew/test/support/fixtures/test.gif"

    # YouTube tests fail bot detection
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    system bin/"yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
