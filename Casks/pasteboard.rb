cask "pasteboard" do
  version "2.10"
  sha256 "f61ae363d355339f2d642e9214775df8998f8b1c765900d39acb20540e52ab2a"

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

  postflight_steps do
    # Self-signed (not notarized): clear quarantine so it opens without the
    # right-click-Open dance.
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/PasteBoard.app"]
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
