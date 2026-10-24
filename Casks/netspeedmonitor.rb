cask "netspeedmonitor" do
  version "1.9"
  sha256 "6b332d6dc289e1ad942b17dd110bb6748d525c0b7fb8113235be3e60b5fa1e53"

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
