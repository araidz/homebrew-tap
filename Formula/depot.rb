class Depot < Formula
  desc "Lightweight macOS installer & firmware downloader TUI"
  homepage "https://github.com/araidz/Depot"
  version "0.1.2"
  url "https://github.com/araidz/Depot/archive/refs/tags/v#{version}.tar.gz"
  sha256 "3439d30fa252cf8790be045a5781c8f79055c7508f61dc595ed657faf09a3187"
  license "MIT"

  depends_on "aria2"
  depends_on "python@3.14"

  def install
    libexec.install "depot"
    (bin/"depot").write <<~SH
      #!/bin/sh
      export PYTHONPATH="#{libexec}:$PYTHONPATH"
      exec "#{formula_opt_bin("python@3.14")}/python3.14" -m depot "$@"
    SH
  end

  test do
    assert_match "macOS installer", shell_output("#{bin}/depot --help")
  end
end
