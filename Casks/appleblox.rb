cask "appleblox" do
  arch arm: "arm64", intel: "x64"

  version "0.8.5"
  on_arm do
    sha256 ""
  end
  on_intel do
    sha256 ""
  end

  url "https://github.com/AppleBlox/appleblox/releases/download/#{version}/AppleBlox-#{version}_#{arch}.dmg",
      verified: "github.com/AppleBlox/appleblox/"

  name "AppleBlox"
  desc "Roblox launcher for macOS, inspired by Bloxstrap"
  homepage "https://appleblox.com/"

  livecheck do
    url "https://github.com/AppleBlox/appleblox/releases"
    strategy :git
  end

  conflicts_with cask: "appleblox@dev"

  depends_on macos: ">= :mojave"
  depends_on cask: "roblox"

  app "AppleBlox.app"

  zap trash: [
    "~/Library/Caches/ch.origaming.appleblox",
    "~/Library/HTTPStorages/ch.origaming.appleblox",
    "~/Library/Preferences/ch.origaming.appleblox.plist",
    "~/Library/Saved Application State/ch.origaming.appleblox.savedState",
  ]
end