cask "statsai-desktop" do
  version "0.1.0"
  sha256 "9e6c3d2ce3c811212649e83995f82a1552b8332b0297aa06df01cd2a61d93004"

  url "https://github.com/StatsAIDev/statsai-desktop/releases/download/desktop-v#{version}/StatsAI_#{version}_universal.dmg"
  name "StatsAI"
  desc "Dashboard for local AI coding tool usage statistics"
  homepage "https://statsai.dev/"

  livecheck do
    url :url
    regex(/^desktop[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

  app "StatsAI.app"

  zap trash: [
    "~/Library/Application Support/dev.statsai.desktop",
    "~/Library/Caches/dev.statsai.desktop",
    "~/Library/HTTPStorages/dev.statsai.desktop",
    "~/Library/Preferences/dev.statsai.desktop.plist",
    "~/Library/Saved Application State/dev.statsai.desktop.savedState",
    "~/Library/WebKit/dev.statsai.desktop",
  ]
end
