class Trawl < Formula
  desc "Curated, terminal-native torrent finder over aria2"
  homepage "https://github.com/araidz/Trawl"
  version "0.2.8"
  url "https://github.com/araidz/Trawl/archive/refs/tags/v#{version}.tar.gz"
  sha256 "29688daa1feeef9d6d23c7132cec6a9c240fb1f6ad40f93c164a4f76b5ddd86d"
  license "MIT"

  depends_on "aria2"
  depends_on "python@3.14"

  def install
    libexec.install "trawl"
    (bin/"trawl").write <<~SH
      #!/bin/sh
      export PYTHONPATH="#{libexec}:$PYTHONPATH"
      exec "#{formula_opt_bin("python@3.14")}/python3.14" -m trawl "$@"
    SH
  end

  test do
    assert_match "terminal torrent finder", shell_output("#{bin}/trawl --help")
  end
end
