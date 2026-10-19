cask "statsai-desktop" do
  version "0.1.2"
  sha256 "a36c2659002087bf88faf92ca77750d1bcbb967a2ef1d7275e5bb0a6cabf444a"

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

  caveats <<~EOS
    The StatsAI CLI's menu bar app was named StatsAI.app before CLI v0.7.3,
    and installing this cask fails while that app is in /Applications. Update
    the menu bar app to v0.7.3 or later, which is named StatsAIMenuBar.app,
    and open it once: it moves the old StatsAI.app to the Trash and moves its
    login item. Or quit the old menu bar app and move it out of /Applications.
  EOS
end
