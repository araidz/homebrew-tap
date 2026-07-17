cask "netspeedmonitor" do
  version "1.3"
  sha256 "999650d93d5351fc7341496dcae55275877ad97b4174878373df1db8c125ba7f"

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
