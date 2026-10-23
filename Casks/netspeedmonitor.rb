cask "netspeedmonitor" do
  version "1.7"
  sha256 "9ab16197e02070a364db9fab0e381817f50b0edde2353e35ceb6ac2f26092780"

  url "https://github.com/araidz/NetSpeedMonitor/releases/download/v#{version}/NetSpeedMonitor.zip"
  name "NetSpeedMonitor"
  desc "Menu bar app showing live upload/download speed"
  homepage "https://github.com/araidz/NetSpeedMonitor"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "NetSpeedMonitor.app"

  postflight_steps do
    # Ad-hoc signed (not notarized): clear quarantine so it opens without the
    # right-click-Open dance.
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/NetSpeedMonitor.app"]
  end

  zap trash: "~/Library/Preferences/com.araidz.NetSpeedMonitor.plist"
end
