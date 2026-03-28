cask "appleblox@dev" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0-dev.41"
  sha256 arm:   "528c21cb768afa3f94f708bb9cc1bbc37a29e2b0ca366ac192f520cd38db6145",
         intel: "1d4f644bee698661ba949a9cab4097bd54a49d4a6a071eac52a510f036c7b9af"

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
