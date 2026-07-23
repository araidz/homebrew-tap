class Slipway < Formula
  desc "Lightweight macOS installer & firmware downloader TUI"
  homepage "https://github.com/araidz/Slipway"
  version "0.1.3"
  url "https://github.com/araidz/Slipway/archive/refs/tags/v#{version}.tar.gz"
  sha256 "e92ae8e789dbed684f3f3d9316ba522e22277e8010f3522a096be048a4f6a361"
  license "MIT"

  depends_on "aria2"
  depends_on "python@3.14"

  def install
    libexec.install "slipway"
    (bin/"slipway").write <<~SH
      #!/bin/sh
      export PYTHONPATH="#{libexec}:$PYTHONPATH"
      exec "#{formula_opt_bin("python@3.14")}/python3.14" -m slipway "$@"
    SH
  end

  test do
    assert_match "macOS installer", shell_output("#{bin}/slipway --help")
  end
end
