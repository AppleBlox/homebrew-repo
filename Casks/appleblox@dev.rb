cask "appleblox@dev" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0-dev.32"
  on_arm do
    sha256 "ae74017690f8ea3b378150d949e4b9b0c602f2839318f1312a900c3dc7b10b82"
  end
  on_intel do
    sha256 "cb3ac4f6dc0b13ea2d2aba4b193a926586dd4671609f2529a9ec7e96f79c78a7"
  end
         
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