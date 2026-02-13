# Using Homebrew to Manage AppleBlox

Managing AppleBlox through Homebrew is the most efficient way to handle installation, seamless updates, and switching between stable and development versions without losing your settings or data. Here's how to get started.

## Prerequisites

Before starting, ensure you have Homebrew installed. If you don't, follow the instructions on [brew.sh](https://brew.sh/) to install Homebrew.

## Note

**If you already have a manual installation of AppleBlox** (e.g., you dragged it into your Applications folder previously), it is recommended to move that old version to the Trash before running the install commands below.

* Note: Moving the app to the Trash does **not** delete your user data, saves, or settings. Those are stored separately and will be picked up by the Homebrew version automatically.*

### **1. Setup the Repository**

You need to add the official AppleBlox tap to your Homebrew configuration. This allows Homebrew to find and track the AppleBlox packages.

Open your Terminal app and run this command to add the AppleBlox tap.

```bash
brew tap AppleBlox/homebrew-repo
```

### **2. Installation & Version Management**

You can choose to install the Stable release (recommended) or the Development release.

#### **Option A: Install Stable (Recommended)**

Use this for the most reliable experience.

```bash
brew install --cask appleblox
```

#### **Option B: Install Development (Unstable)**

Use this if you want to test the newest features before they are fully released.

```bash
brew install --cask appleblox@dev
```

### **3. Keeping AppleBlox Updated**

One of the main benefits of using Homebrew is easy updates. You dont need to manually download new versions.

To update AppleBlox (and all your other Homebrew apps):

```bash
brew update && brew upgrade --cask && brew cleanup
```

**Important:** Updating via Homebrew preserves all your internal app data, themes, and mods.

### **4. Uninstallation**

If you need to remove AppleBlox, you have two methods depending on whether you want to save your configuration.

**Standard Uninstall (Keeps Data)**
Removes the app but **keeps** your settings and data (including mods and flags) in AppleBlox's 'Application Support' folder. Use this if you plan to reinstall later.

```bash
brew uninstall appleblox
```

* **Clean Uninstall (Deletes Everything)**
Removes the app **and** wipes all associated settings, caches, and local data.

```bash
brew uninstall --zap appleblox
```

* Replace `appleblox` with `appleblox@dev` depending on your installation

Any questions? Ping @bakathesussy
