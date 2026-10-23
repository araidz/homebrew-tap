cask "msgviewer" do
  version "0.1.13"
  sha256 "c1df873a6fc7821456dcec5c6a59894b2096e07de309dce0e1d49eb754eff833"

  url "https://github.com/araidz/MSGViewer/releases/download/v#{version}/MSGViewer.app.zip"
  name "MSG Viewer"
  desc "Lightweight native viewer for Microsoft Outlook MSG files"
  homepage "https://github.com/araidz/MSGViewer"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "MSGViewer.app"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/MSGViewer.app"]
  end

  zap trash: "~/Library/Preferences/io.github.araidz.msgviewer.plist"

  caveats "MSGViewer is ad-hoc signed and processes messages entirely on this Mac."
end
