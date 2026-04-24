#!/usr/bin/env python3
"""
update_casks.py — Automated Homebrew cask updater for AppleBlox.

Functionally equivalent to the original Bash workflow:
  - Fetches latest stable release via `gh` CLI (non-draft, ignoring pre-release flag)
  - Fetches latest dev version from the dev branch package.json
  - Downloads dev assets in parallel, validates file size + type
  - Patches version and sha256 in Cask .rb files (multi-line aware)
  - Verifies patches, stages changed files with `git add`
  - Outputs GitHub Actions ::group:: markers for collapsible log sections
"""

import os
import re
import sys
import json
import hashlib
import logging
import subprocess
import time
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.DEBUG,
    format="[%(asctime)s] [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    stream=sys.stderr,
)
log = logging.getLogger("update_casks")

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
REPO = os.environ.get("REPO", "AppleBlox/appleblox")

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def run(cmd: list[str], *, check: bool = True) -> subprocess.CompletedProcess:
    """Run a command, log it, and optionally check its return code."""
    log.info("[exec] %s", " ".join(cmd))
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.stdout.strip():
        log.debug("stdout: %s", result.stdout.strip())
    if result.stderr.strip():
        log.debug("stderr: %s", result.stderr.strip())
    if check and result.returncode != 0:
        log.error("Command failed (exit %d): %s", result.returncode, " ".join(cmd))
        log.error("stdout: %s", result.stdout)
        log.error("stderr: %s", result.stderr)
        raise subprocess.CalledProcessError(result.returncode, cmd, result.stdout, result.stderr)
    return result


def validate_sha256(digest: str, label: str) -> bool:
    """Return True if *digest* is a valid 64-char lowercase hex string."""
    if not re.fullmatch(r"[0-9a-f]{64}", digest):
        log.error("Invalid SHA256 for %s: '%s'", label, digest)
        return False
    return True


def get_cask_version(path: str) -> str | None:
    """Extract the version string from a .rb cask file."""
    if not os.path.isfile(path):
        return None
    content = Path(path).read_text()
    m = re.search(r'version\s+"(.+?)"', content)
    return m.group(1) if m else None


def extract_digest(assets: list[dict], pattern: str, label: str) -> str | None:
    """
    Find the first asset whose name matches *pattern* (regex) and return its
    sha256 digest (with the ``sha256:`` prefix stripped).  Returns None on
    failure, logging diagnostics.
    """
    for asset in assets:
        if re.search(pattern, asset["name"]):
            raw = asset.get("digest", "")
            digest = raw.removeprefix("sha256:")
            if validate_sha256(digest, label):
                return digest
            return None  # invalid digest

    log.error("No asset matching '%s' found for %s", pattern, label)
    log.error("Available assets: %s", [a["name"] for a in assets])
    return None


# ---------------------------------------------------------------------------
# Cask patching
# ---------------------------------------------------------------------------

def update_cask(
    cask_name: str,
    new_version: str,
    sha256_arm: str,
    sha256_intel: str,
) -> bool:
    """
    Patch *cask_name* (.rb file in ``Casks/``) with *new_version* and the two
    sha256 hashes, then commit the file with a descriptive message.
    Returns True on success.
    """
    cask_file = f"Casks/{cask_name}.rb"
    print(f"::group::Updating {cask_name} to {new_version}")

    if not os.path.isfile(cask_file):
        log.error("Cask file not found: %s", cask_file)
        print("::endgroup::")
        return False

    content = Path(cask_file).read_text()
    log.debug("--- File Content Before ---")
    log.debug("\n%s", content)
    log.debug("---------------------------")

    current = get_cask_version(cask_file)
    log.info("Current version: %s", current)
    log.info("New version    : %s", new_version)

    if current == new_version:
        log.info("%s is already at the latest version.", cask_name)
        print("::endgroup::")
        return True

    log.info("Version mismatch detected. Patching...")

    # Validate hashes before patching
    if not validate_sha256(sha256_arm, f"{cask_name} ARM"):
        print("::endgroup::")
        return False
    if not validate_sha256(sha256_intel, f"{cask_name} Intel"):
        print("::endgroup::")
        return False

    original = content

    # Patch version
    content = re.sub(r'(version\s+)"[^"]+"', rf'\1"{new_version}"', content)
    # Patch sha256 arm (multi-line aware)
    content = re.sub(r'(sha256\s+arm:\s+)"[^"]+"', rf'\1"{sha256_arm}"', content)
    # Patch sha256 intel (multi-line aware)
    content = re.sub(r'(intel:\s+)"[^"]+"', rf'\1"{sha256_intel}"', content)

    if content == original:
        log.error("Patching made no changes to %s", cask_file)
        print("::endgroup::")
        return False

    Path(cask_file).write_text(content)

    # Post-patch verification
    patched = get_cask_version(cask_file)
    if patched != new_version:
        log.error(
            "Post-patch verification failed: version is '%s', expected '%s'",
            patched, new_version,
        )
        print("::endgroup::")
        return False

    log.debug("--- File Content After ---")
    log.debug("\n%s", content)
    log.debug("--------------------------")

    # Commit with a descriptive message per Homebrew guidelines
    log.info("Committing changes for %s", cask_file)
    run(["git", "add", cask_file])
    run(["git", "commit", "-m", f"{cask_name} {new_version}"])

    print("::endgroup::")
    return True


# ---------------------------------------------------------------------------
# Stable build
# ---------------------------------------------------------------------------

def handle_stable() -> bool:
    """Process the stable cask.  Returns False only on hard errors."""
    print("--- STABLE BUILD ---")

    # List all releases for diagnostics
    try:
        result = run(
            ["gh", "release", "list", "-R", REPO, "--limit", "10",
             "--json", "tagName,isDraft,isPrerelease"],
            check=False,
        )
        if result.returncode == 0 and result.stdout.strip():
            releases = json.loads(result.stdout)
            log.info("Available releases:")
            for r in releases:
                log.info(
                    "  %s (Prerelease: %s, Draft: %s)",
                    r["tagName"], r["isPrerelease"], r["isDraft"],
                )
        else:
            log.warning("No releases found or gh command failed.")
            return True  # non-fatal
    except Exception as exc:
        log.warning("Could not list releases: %s", exc)
        return True

    # Pick the latest non-draft release (ignore pre-release flag)
    active = [r for r in releases if not r["isDraft"]]
    if not active:
        log.warning("Could not determine latest stable version. Skipping stable build update.")
        return True

    version = active[0]["tagName"]
    log.info("Latest Stable: %s", version)

    current = get_cask_version("Casks/appleblox.rb")
    if current == version:
        log.info("appleblox is already at the latest version (%s). Skipping update.", version)
        return True

    # Fetch assets
    log.info("Fetching assets for version %s", version)
    assets_raw = run(["gh", "release", "view", version, "-R", REPO, "--json", "assets"])
    assets_data = json.loads(assets_raw.stdout)
    assets = assets_data.get("assets", [])

    sha_arm = extract_digest(assets, r"_arm64\.dmg$", "stable ARM")
    sha_intel = extract_digest(assets, r"_x64\.dmg$", "stable Intel")

    if not sha_arm or not sha_intel:
        log.error("Missing digests for stable release. Skipping.")
        return False

    log.info("ARM SHA  : %s", sha_arm)
    log.info("Intel SHA: %s", sha_intel)

    return update_cask("appleblox", version, sha_arm, sha_intel)


# ---------------------------------------------------------------------------
# Dev build
# ---------------------------------------------------------------------------

def download_dev_asset(arch: str, version: str) -> str | None:
    """
    Download a dev build zip, validate it, compute its SHA256, clean up, and
    return the hex digest.  Returns None on failure.
    """
    url = (
        f"https://nightly.link/{REPO}/workflows/build/dev/"
        f"AppleBlox-{arch}-{version}.pkg.zip"
    )
    output = f"dev_{arch}.zip"
    log.info("Downloading %s from %s", arch, url)

    # Download with retries
    last_err = None
    for attempt in range(1, 4):
        try:
            urllib.request.urlretrieve(url, output)
            last_err = None
            break
        except (urllib.error.URLError, OSError) as exc:
            last_err = exc
            log.warning("Download attempt %d failed for %s: %s. Retrying...", attempt, arch, exc)
            time.sleep(5)

    if last_err is not None:
        log.error("Failed to download %s build from %s: %s", arch, url, last_err)
        return None

    # --- Validate ---
    try:
        size = os.path.getsize(output)
        if size < 1000:
            log.error("Downloaded %s file is suspiciously small (%d bytes)", arch, size)
            return None

        # Check it's actually a zip (magic bytes PK\x03\x04)
        with open(output, "rb") as fh:
            magic = fh.read(4)
        if magic[:2] != b"PK":
            log.error("Downloaded %s file is not a valid zip archive (magic: %s)", arch, magic)
            return None

        # Compute SHA256
        sha = hashlib.sha256()
        with open(output, "rb") as fh:
            for chunk in iter(lambda: fh.read(8192), b""):
                sha.update(chunk)
        digest = sha.hexdigest()
        log.info("Computed SHA256 for %s: %s", arch, digest)
        return digest

    except Exception as exc:
        log.error("Error processing %s build: %s", arch, exc)
        return None
    finally:
        if os.path.exists(output):
            os.remove(output)


def handle_dev() -> bool:
    """Process the dev cask.  Returns False on hard errors."""
    print("")
    print("--- DEV BUILD ---")

    # Fetch version from package.json on dev branch
    url = f"https://raw.githubusercontent.com/{REPO}/dev/package.json"
    log.info("Fetching dev version from %s", url)
    try:
        with urllib.request.urlopen(url, timeout=30) as resp:
            pkg = json.loads(resp.read().decode())
        version = pkg.get("version")
    except Exception as exc:
        log.error("Could not determine latest dev version: %s", exc)
        return False

    if not version:
        log.error("Could not determine latest dev version (empty/null)")
        return False

    log.info("Latest Dev: %s", version)

    current = get_cask_version("Casks/appleblox@dev.rb")
    if current == version:
        log.info("appleblox@dev is already at the latest version (%s). Skipping update.", version)
        return True

    # Download both architectures in parallel
    with ThreadPoolExecutor(max_workers=2) as pool:
        fut_arm = pool.submit(download_dev_asset, "arm64", version)
        fut_intel = pool.submit(download_dev_asset, "x64", version)
        sha_arm = fut_arm.result()
        sha_intel = fut_intel.result()

    if not sha_arm or not sha_intel:
        log.error("Skipping dev update due to download failures.")
        return False

    log.info("ARM SHA  : %s", sha_arm)
    log.info("Intel SHA: %s", sha_intel)

    return update_cask("appleblox@dev", version, sha_arm, sha_intel)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> int:
    ok = True

    if not handle_stable():
        ok = False

    if not handle_dev():
        ok = False

    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
