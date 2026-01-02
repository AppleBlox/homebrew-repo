cask "appleblox@dev" do
  version :latest
  sha256 :no_check

  # Nightly build URL; {arch} will select arm64 or x64
  url "https://nightly.link/AppleBlox/appleblox/workflows/build/dev/AppleBlox-#{version}-dev.#{arch}.dmg.zip"

  name "AppleBlox (Dev)"
  desc "⚠️ Nightly development build of AppleBlox. Not recommended for daily use. Things could break at any time."
  homepage "https://appleblox.com/"

  conflicts_with cask: "appleblox"

  depends_on macos: ">= :high_sierra"
  depends_on cask: "roblox"

  app "AppleBlox.app"

  zap trash: [
    "~/Library/Application Support/AppleBlox",
  ]
end