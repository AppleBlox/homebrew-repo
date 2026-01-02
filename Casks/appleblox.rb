cask "appleblox" do
  arch arm: "arm64", intel: "x64"

  version "0.8.6"
  sha256 arm:   "2dec8668eb2478e13afaafea7773540cc138c2e5e54fe060a1d095747e5abaa9",
         intel: "54cd2363713e1cd510ef891c8329de39a3ac5dd252239140dde3780b13e7453b"

  url "https://github.com/AppleBlox/appleblox/releases/download/#{version}/AppleBlox-#{version}_#{arch}.dmg",
      verified: "github.com/AppleBlox/appleblox/"

  name "AppleBlox"
  desc "Roblox launcher for macOS, inspired by Bloxstrap"
  homepage "https://appleblox.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: "appleblox@dev"

  depends_on macos: ">= 10.13"
  depends_on cask: "roblox"

  app "AppleBlox.app"

  zap trash: [
    "~/Library/Caches/ch.origaming.appleblox",
    "~/Library/HTTPStorages/ch.origaming.appleblox",
    "~/Library/Preferences/ch.origaming.appleblox.plist",
    "~/Library/Saved Application State/ch.origaming.appleblox.savedState",
  ]
end