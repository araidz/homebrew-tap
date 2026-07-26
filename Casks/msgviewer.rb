cask "msgviewer" do
  version "0.1.5"
  sha256 "5fbd94251552bc0d18ae2e12c0b44817393ab08a7cb48360b5f241044537d23b"

  url "https://github.com/araidz/MSGViewer/releases/download/v#{version}/MSGViewer.app.zip"
  name "MSG Viewer"
  desc "Lightweight native viewer for Microsoft Outlook MSG files"
  homepage "https://github.com/araidz/MSGViewer"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "MSGViewer.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/MSGViewer.app"]
  end

  zap trash: "~/Library/Preferences/io.github.araidz.msgviewer.plist"

  caveats "MSGViewer is ad-hoc signed and processes messages entirely on this Mac."
end
