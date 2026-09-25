cask "msgviewer" do
  version "0.1.10"
  sha256 "ab218da77da34b240a274817a5468049af1d9de4aaf93f324b3e031e69deec94"

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
