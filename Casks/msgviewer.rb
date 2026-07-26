cask "msgviewer" do
  version "0.1.0"
  sha256 "0a0e0fcd7a570d1a91bfc7e3f5770a95da44683ae3299e025ca0f17fd90d3d69"

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
