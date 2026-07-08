cask "pasteboard" do
  version "2.0"
  sha256 "dca7b43ac9f7109fd6ce828a34e3dde06ce22901449edc54de8bca1389976100"

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
