cask "appleblox@dev" do
  arch arm: "arm64", intel: "d1e9cc30a3054862fbb1abfb26b0f0ee7f05a1c889ce9d910118577adf39393c"

  version "0.9.0-dev.44"
  sha256 arm:   "e77b54adaca0dbd3cc8f2591a44e8143ed9a7c7ae564277a09ce929ecf3b504b",
         intel: "d1e9cc30a3054862fbb1abfb26b0f0ee7f05a1c889ce9d910118577adf39393c"

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
