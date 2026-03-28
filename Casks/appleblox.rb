cask "appleblox" do
  arch arm: "arm64", intel: "x64"

  version "0.8.6"
  sha256 arm:   "37f51fd6ebf5e15367816b807797cde69fb96eb6e44f9a726a19ea482e19d07c",
         intel: "70104710d2977875356a6384e291d08a1883208faae89550e2ceb14e1dd74837"

  url "https://github.com/AppleBlox/appleblox/releases/download/#{version}/AppleBlox-#{version}_#{arch}.dmg",
      verified: "github.com/AppleBlox/appleblox/"
  name "AppleBlox"
  desc "Roblox launcher for macOS, inspired by Bloxstrap"
  homepage "https://appleblox.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "appleblox@dev"
  depends_on cask: "roblox"

  app "AppleBlox.app"

  zap trash: [
    "~/Library/Application Support/appleblox",
    "~/Library/Caches/ch.origaming.appleblox",
    "~/Library/HTTPStorages/ch.origaming.appleblox",
    "~/Library/Preferences/ch.origaming.appleblox.plist",
    "~/Library/Saved Application State/ch.origaming.appleblox.savedState",
  ]
end
