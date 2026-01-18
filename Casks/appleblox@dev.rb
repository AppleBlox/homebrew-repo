cask "appleblox@dev" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0-dev.30"
  on_arm do
    sha256 "310fdc20709e98216fa0d8361ab91b84c31f233170bbb2ff7f645b5b22c80c54"
  end
  on_intel do
    sha256 "39f6fefa6f30476f9dc2e154ba4149f33cfd0759c5f8ddc8bea3c0d3139ce8e6"
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