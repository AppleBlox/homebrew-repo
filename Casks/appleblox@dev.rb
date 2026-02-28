cask "appleblox@dev" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0-dev.39"
  on_arm do
    sha256 "20cc5fe94e92724160172598f5d03285ccd04843bb80267b518a4367d342adff"
  end
  on_intel do
    sha256 "dacf32a1983c402f36cf8775814ba2022424d5de8fd5863663da47a2948da424"
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