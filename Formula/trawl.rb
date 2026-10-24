class Trawl < Formula
  desc "Curated, terminal-native torrent finder over aria2"
  homepage "https://github.com/araidz/Trawl"
  version "0.6.0"
  url "https://github.com/araidz/Trawl/archive/refs/tags/v#{version}.tar.gz"
  sha256 "4b76ddebe0bb300eb929a39676929615e3215e595fb12b6c2685618ca9f1a803"
  license "MIT"

  depends_on "aria2"
  depends_on "python@3.15"

  def install
    libexec.install "trawl"
    (bin/"trawl").write <<~SH
      #!/bin/sh
      export PYTHONPATH="#{libexec}:$PYTHONPATH"
      exec "#{formula_opt_bin("python@3.15")}/python3.15" -m trawl "$@"
    SH
  end

  test do
    assert_match "terminal torrent finder", shell_output("#{bin}/trawl --help")
  end
end
