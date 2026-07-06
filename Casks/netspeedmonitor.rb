cask "netspeedmonitor" do
  version "1.1"
  sha256 "bf758890b623e9a3e53d3da7dfc498805c5e92d4d322d179cdfeaa65cf93dbb0"

  url "https://github.com/araidz/NetSpeedMonitor/releases/download/v#{version}/NetSpeedMonitor.zip"
  name "NetSpeedMonitor"
  desc "Menu bar app showing live upload/download speed"
  homepage "https://github.com/araidz/NetSpeedMonitor"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "NetSpeedMonitor.app"

  postflight do
    # Ad-hoc signed (not notarized): clear quarantine so it opens without the
    # right-click-Open dance.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/NetSpeedMonitor.app"]
  end

  zap trash: "~/Library/Preferences/com.araidz.NetSpeedMonitor.plist"
end
