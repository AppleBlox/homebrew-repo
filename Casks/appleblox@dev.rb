cask "appleblox@dev" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0-dev.28"
  sha256 arm:   "794ffd03c96c1266579db06c2878171a35c36457f7267d90be728d77a003fcb5",
         intel: "050fc0d8c38b29a941918d12ddea2f60d7182e268b43f8b51ef946643ce33e83"

  url "https://nightly.link/AppleBlox/appleblox/workflows/build/dev/AppleBlox-#{version}_#{arch}.dmg.zip",
      verified: "nightly.link/AppleBlox/appleblox"
  name "AppleBlox (Dev)"
  desc "⚠️ Nightly development build of AppleBlox. Not recommended for daily use. Things could break at any time."
  homepage "https://appleblox.com/"

  livecheck do
    url "https://raw.githubusercontent.com/AppleBlox/appleblox/dev/package.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  conflicts_with cask: "appleblox"

  depends_on cask: "roblox"

  app "AppleBlox.app"

  zap trash: [
    "~/Library/Caches/ch.origaming.appleblox",
    "~/Library/HTTPStorages/ch.origaming.appleblox",
    "~/Library/Preferences/ch.origaming.appleblox.plist",
    "~/Library/Saved Application State/ch.origaming.appleblox.savedState",
  ]
end