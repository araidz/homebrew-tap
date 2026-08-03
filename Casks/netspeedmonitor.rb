cask "netspeedmonitor" do
  version "1.5"
  sha256 "d8721de77c277bd80014317613ad1ad364032ca0a3b0c2c3d64a79399647e1c8"

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
