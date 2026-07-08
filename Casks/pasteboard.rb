cask "pasteboard" do
  version "2.0"
  sha256 "2f70235d1f6d5d4ee8823d4d296fbc44ba38f36b64626e7a332543fb0a2ff175"

  url "https://github.com/araidz/PasteBoard/releases/download/v#{version}/PasteBoard.dmg"
  name "PasteBoard"
  desc "Clipboard history manager for the menu bar"
  homepage "https://github.com/araidz/PasteBoard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "PasteBoard.app"

  postflight do
    # Self-signed (not notarized): clear quarantine so it opens without the
    # right-click-Open dance.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/PasteBoard.app"]
  end

  zap trash: [
    "~/Library/Application Support/PasteBoard",
    "~/Library/Preferences/com.local.pasteboard.plist",
  ]

  caveats <<~EOS
    PasteBoard needs Accessibility to paste directly into other apps:
    System Settings → Privacy & Security → Accessibility. Without it, picking a
    clip still copies — press ⌘V yourself.
  EOS
end
