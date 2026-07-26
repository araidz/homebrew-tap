cask "msgviewer" do
  version "0.1.6"
  sha256 "c95736ebcfd3effe829d9212dd502ed6360b640424b1da3de024e63fe2d93b78"

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
