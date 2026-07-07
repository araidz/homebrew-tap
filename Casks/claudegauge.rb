cask "claudegauge" do
  version "0.1.6"
  sha256 "3b4d6c4b438eabdf1b8beb604dbfe67f146adedd08fbc2668eed7f4850af908f"

  url "https://github.com/araidz/ClaudeGauge/releases/download/v#{version}/ClaudeGauge.app.zip"
  name "ClaudeGauge"
  desc "Menu bar monitor for Claude usage limits (session + weekly) and local context tokens"
  homepage "https://github.com/araidz/ClaudeGauge"

  depends_on macos: :ventura

  app "ClaudeGauge.app"

  # Ad-hoc signed (not notarized): strip the quarantine Homebrew stamps on, so
  # Gatekeeper doesn't block first launch. Safe for a self-built personal tool.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/ClaudeGauge.app"]
  end

  caveats <<~EOS
    ClaudeGauge is an unofficial, ad-hoc-signed personal tool.
    First launch: it lives in the menu bar (no Dock icon). Open the menu and
    choose "Log in..." to authorize with your Claude account.
  EOS
end
