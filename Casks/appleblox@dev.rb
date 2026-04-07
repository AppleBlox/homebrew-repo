cask "appleblox@dev" do
  arch arm: "arm64", intel: "2d86b0f052369d6111c74ed18d0bc9ec2edcee835cf99f0b4eb8f88c6f2ad347"

  version "0.9.1-dev.0"
  sha256 arm:   "e38c8d46630bc4a58a1f8097c27065dbac51b1351b5627fb1d8b60eaa364166d",
         intel: "2d86b0f052369d6111c74ed18d0bc9ec2edcee835cf99f0b4eb8f88c6f2ad347"

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

  preflight do
    # Expand the PKG manually to bypass the relocatable behavior of the macOS 'installer'
    system_command "pkgutil", args: ["--expand-full", "#{staged_path}/AppleBlox-#{arch}-#{version}.pkg", "#{staged_path}/expanded"]
  end

  app "expanded/AppleBlox.pkg/Payload/AppleBlox.app"


  zap trash: [
    "~/Library/Application Support/appleblox",
    "~/Library/Caches/ch.origaming.appleblox",
    "~/Library/HTTPStorages/ch.origaming.appleblox",
    "~/Library/Preferences/ch.origaming.appleblox.plist",
    "~/Library/Saved Application State/ch.origaming.appleblox.savedState",
  ]
end
