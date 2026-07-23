class Ferry < Formula
  desc "Connect to free VPN Gate servers from a terminal TUI"
  homepage "https://github.com/araidz/Ferry"
  version "0.3.0"
  url "https://github.com/araidz/Ferry/archive/refs/tags/v#{version}.tar.gz"
  sha256 "00bbba46ab1257b1f6c683b90628a292dd0b32433ab72c1322ef72ac166ec1b0"
  license "MIT"

  depends_on "openvpn"
  depends_on "python@3.14"

  def install
    libexec.install "ferry"
    (bin/"ferry").write <<~SH
      #!/bin/sh
      export PYTHONPATH="#{libexec}:$PYTHONPATH"
      exec "#{formula_opt_bin("python@3.14")}/python3.14" -m ferry "$@"
    SH
  end

  test do
    assert_match "terminal", shell_output("#{bin}/ferry --help")
  end
end
