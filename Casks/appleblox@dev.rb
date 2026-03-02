cask "appleblox@dev" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0-dev.40"
  sha256 arm:   "33e6d00cebddbb8f778649182f1543eea0d7bc474db762799c188a01eb59ed8b",
         intel: "e2ed93d4145bc3da773fb23e9d4ce8257f08d716b3034cb689788ac7abe6299b"

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

  preflight do
    # Expand the PKG manually to bypass the relocatable behavior of the macOS 'installer'
    system_command "pkgutil", args: ["--expand-full", "#{staged_path}/AppleBlox-#{arch}-#{version}.pkg", "#{staged_path}/expanded"]
  end

  app "expanded/AppleBlox.pkg/Payload/AppleBlox.app"

  uninstall delete: "/Applications/AppleBlox.app"

  zap trash: [
    "~/Library/Caches/ch.origaming.appleblox",
    "~/Library/HTTPStorages/ch.origaming.appleblox",
    "~/Library/Preferences/ch.origaming.appleblox.plist",
    "~/Library/Saved Application State/ch.origaming.appleblox.savedState",
  ]
end
