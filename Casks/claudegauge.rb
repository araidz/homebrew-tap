cask "claudegauge" do
  version "0.1.4"
  sha256 "ceac7ed7fd90ae1fc98a793d247923ab5c9cce07bba51980dd91c05546bbfb53"

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
