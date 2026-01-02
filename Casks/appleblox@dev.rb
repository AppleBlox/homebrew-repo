cask "appleblox" do
  arch arm: "arm64", intel: "x64"

  version "X.Y.Z"

  on_arm do
    sha256 "ARM_SHA"
  end
  on_intel do
    sha256 "INTEL_SHA"
  end

  url "https://github.com/AppleBlox/appleblox/releases/download/#{version}/AppleBlox-#{version}_#{arch}.dmg",
      verified: "github.com/AppleBlox/appleblox/"

  name "AppleBlox"
  desc "⚠️ - Nightly Build of AppleBlox. Not recommended for daily use. Things could break at any time."
  homepage "https://appleblox.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  depends_on macos: ">= :high_sierra"
  depends_on cask: "roblox"

  app "AppleBlox.app"

  zap trash: [
    "~/Library/Application Support/AppleBlox",
  ]
end