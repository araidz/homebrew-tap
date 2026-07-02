cask "lidless" do
  version "0.1.1"
  sha256 "0e85d48711eaa6331ca672e2050344cdd66e4c2430a69cccfdfbc00885515b72"

  url "https://github.com/nghialuong/Lidless/releases/download/v#{version}/Lidless-#{version}.dmg",
      verified: "github.com/nghialuong/Lidless/"
  name "Lidless"
  desc "Keeps the system awake while the lid is closed"
  homepage "https://github.com/nghialuong/Lidless"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "Lidless.app"

  zap trash: "~/Library/Preferences/com.nghialuong.lidless.plist"

  caveats <<~EOS
    Lidless installs a privileged helper (root LaunchDaemon) via SMAppService the
    first time you enable keep-awake. Homebrew cannot remove that helper: before
    uninstalling, disable keep-awake and quit Lidless (a reboot resets the sleep
    flag either way).
  EOS
end
