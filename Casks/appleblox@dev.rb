cask "appleblox@dev" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0-dev.40"
  on_arm do
    sha256 "694f3d65bf114e7a041dcd67b3d1c2b8aa28ee1f1c8c61b25dd1c415b20a6e28"
  end
  on_intel do
    sha256 "cb5845c5d3e189ff76216a4636f4aa732bcd28c24041d8dd839fa7e6ed317965"
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

  app "AppleBlox.app"

  zap trash: [
    "~/Library/Caches/ch.origaming.appleblox",
    "~/Library/HTTPStorages/ch.origaming.appleblox",
    "~/Library/Preferences/ch.origaming.appleblox.plist",
    "~/Library/Saved Application State/ch.origaming.appleblox.savedState",
  ]
end