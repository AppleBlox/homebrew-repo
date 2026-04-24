cask "appleblox@dev" do
  arch arm: "arm64", intel: "4a52785b8e2ccbb61fb26ada0776ca0ae35d59c0a15bb55bd91e2abd2ce0018c"

  version "0.9.1-dev.1"
  sha256 arm:   "763215e47d91cd80edbdb011e67e8665795c3c0b486bee1eee0bd82655eb5e3f",
         intel: "4a52785b8e2ccbb61fb26ada0776ca0ae35d59c0a15bb55bd91e2abd2ce0018c"

  url "https://nightly.link/AppleBlox/appleblox/workflows/build/dev/AppleBlox-#{arch}-#{version}.pkg.zip",
      verified: "nightly.link/AppleBlox/appleblox/"
  name "AppleBlox (Dev)"
  desc "Nightly development build of AppleBlox (unstable)"
  homepage "https://appleblox.com/"

  livecheck do
    url "https://raw.githubusercontent.com/AppleBlox/appleblox/dev/package.json"
    strategy :json do |json|
      json["version"]
    end
  end

  conflicts_with cask: "appleblox"
  depends_on cask: "roblox"

  app "expanded/AppleBlox.pkg/Payload/AppleBlox.app"

  preflight do
    system_command "pkgutil", args: ["--expand-full", "#{staged_path}/AppleBlox-#{arch}-#{version}.pkg", "#{staged_path}/expanded"]
  end

  zap trash: [
    "~/Library/Application Support/appleblox",
    "~/Library/Caches/ch.origaming.appleblox",
    "~/Library/HTTPStorages/ch.origaming.appleblox",
    "~/Library/Preferences/ch.origaming.appleblox.plist",
    "~/Library/Saved Application State/ch.origaming.appleblox.savedState",
  ]
end
