cask "netspeedmonitor" do
  version "1.2"
  sha256 "bdf76be40fd44e2ef8cf9a5be1cea505a00261b37efbb7fb3e8bae684d4a25c4"

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

  postflight do
    # Ad-hoc signed (not notarized): clear quarantine so it opens without the
    # right-click-Open dance.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/NetSpeedMonitor.app"]
  end

  zap trash: "~/Library/Preferences/com.araidz.NetSpeedMonitor.plist"
end
