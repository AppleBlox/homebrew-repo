cask "appleblox@dev" do
  arch arm: "arm64", intel: "15850603ed0231b3b995c33c28759ce3187f66a11387bf7ff561cf9c311dc33a"

  version "0.9.0-dev.42"
  sha256 arm:   "ffb0d126447ddb45bfd3d2aef2c5f8736f82e79f86f43108e142f3b098438dcb",
         intel: "15850603ed0231b3b995c33c28759ce3187f66a11387bf7ff561cf9c311dc33a"

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
