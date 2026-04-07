cask "appleblox" do
  arch arm: "arm64", intel: "558e75f01dddae480116c75565129c1f2aa50303a08fea7292af8a61aea0f33b"

  version "0.9.0"
  sha256 arm:   "fd7f9e3c4800b59d2600d242bb6e8ac7f5f683f85e1aad6a98e0a9b1d254faa0",
         intel: "558e75f01dddae480116c75565129c1f2aa50303a08fea7292af8a61aea0f33b"

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
