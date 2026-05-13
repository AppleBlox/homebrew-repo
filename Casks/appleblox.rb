cask "appleblox" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0"
  sha256 arm:   "d3344acdf54173f1bdbc98ffb11e843bc7b57b4c9e007646be7d20a62ac44220",
         intel: "72288d67e7271b8e9ff080f50363470f634ba39a07e552a12dbde7b74c01f0f0"

  url "https://github.com/AppleBlox/appleblox/releases/download/#{version}/AppleBlox-#{version}_#{arch}.dmg",
      verified: "github.com/AppleBlox/appleblox/"
  name "AppleBlox"
  desc "Roblox launcher, inspired by Bloxstrap"
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
