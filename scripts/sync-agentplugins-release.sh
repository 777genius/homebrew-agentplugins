#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SOURCE_REPOSITORY="777genius/universal-agent-plugins"
TAG="${INPUT_TAG:-}"

fail() {
  echo "agentplugins Homebrew sync: $*" >&2
  exit 1
}

[[ -n "${GH_TOKEN:-}" ]] || fail "GH_TOKEN is required"
command -v gh >/dev/null 2>&1 || fail "gh is required"
command -v jq >/dev/null 2>&1 || fail "jq is required"
command -v python3 >/dev/null 2>&1 || fail "python3 is required"
command -v ruby >/dev/null 2>&1 || fail "ruby is required"

if [[ -z "$TAG" ]]; then
  TAG="$(gh release view --repo "$SOURCE_REPOSITORY" --json tagName --jq .tagName)"
fi
[[ "$TAG" =~ ^agentplugins-v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]] \
  || fail "release tag must be an exact stable agentplugins-vX.Y.Z tag"
VERSION="${TAG#agentplugins-v}"

TEMP_ROOT="$(mktemp -d)"
cleanup() {
  rm -rf "$TEMP_ROOT"
}
trap cleanup EXIT HUP INT TERM

release_json="$(gh release view "$TAG" --repo "$SOURCE_REPOSITORY" \
  --json isDraft,isPrerelease,tagName,assets)"
jq -e --arg tag "$TAG" '
  .isDraft == false and .isPrerelease == false and .tagName == $tag and
  ([.assets[].name] | sort) == ([
    "checksums.txt", "release-manifest.json",
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_darwin_amd64"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_darwin_arm64"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_linux_amd64"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_linux_arm64"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_windows_amd64.exe"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_windows_arm64.exe")
  ] | sort)
' <<<"$release_json" >/dev/null || fail "release assets are incomplete or unexpected"

gh release download "$TAG" --repo "$SOURCE_REPOSITORY" \
  --pattern release-manifest.json --dir "$TEMP_ROOT"
MANIFEST="$TEMP_ROOT/release-manifest.json"

jq -e --arg tag "$TAG" --arg version "$VERSION" '
  .schema_version == 2 and .tag == $tag and .version == $version and
  (.commit | test("^[0-9a-f]{40}$")) and
  (.assets | keys | sort) == ([
    "darwin-amd64", "darwin-arm64", "linux-amd64", "linux-arm64",
    "windows-amd64", "windows-arm64"
  ] | sort) and
  all(.assets[];
    (.file | type == "string") and
    (.sha256 | test("^[0-9a-f]{64}$")) and
    (.size | type == "number" and . > 0)
  )
' "$MANIFEST" >/dev/null || fail "release manifest is invalid"

COMMIT="$(jq -r .commit "$MANIFEST")"
TAG_COMMIT="$(gh api "repos/${SOURCE_REPOSITORY}/commits/${TAG}" --jq .sha)"
[[ "$TAG_COMMIT" == "$COMMIT" ]] || fail "release tag does not match the attested source commit"
gh attestation verify "$MANIFEST" \
  --repo "$SOURCE_REPOSITORY" \
  --signer-workflow "github.com/${SOURCE_REPOSITORY}/.github/workflows/agentplugins-release.yml" \
  --source-digest "$COMMIT" >/dev/null \
  || fail "release manifest attestation verification failed"

FORMULA="$TEMP_ROOT/agentplugins.rb"
python3 - "$MANIFEST" "$FORMULA" <<'PY'
import json
import sys
from pathlib import Path

manifest = json.loads(Path(sys.argv[1]).read_text())
version = manifest["version"]
assets = manifest["assets"]
base = (
    "https://github.com/777genius/universal-agent-plugins/releases/download/"
    f"agentplugins-v{version}"
)

def block(platform: str, cpu: str) -> tuple[str, str]:
    asset = assets[f"{platform}-{cpu}"]
    return f'{base}/{asset["file"]}', asset["sha256"]

mac_arm_url, mac_arm_sha = block("darwin", "arm64")
mac_amd_url, mac_amd_sha = block("darwin", "amd64")
linux_arm_url, linux_arm_sha = block("linux", "arm64")
linux_amd_url, linux_amd_sha = block("linux", "amd64")

formula = f'''class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "{version}"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "{mac_arm_url}", using: :nounzip
      sha256 "{mac_arm_sha}"
    else
      url "{mac_amd_url}", using: :nounzip
      sha256 "{mac_amd_sha}"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "{linux_arm_url}", using: :nounzip
      sha256 "{linux_arm_sha}"
    else
      url "{linux_amd_url}", using: :nounzip
      sha256 "{linux_amd_sha}"
    end
  end

  def install
    asset = Dir["agentplugins_*"].fetch(0)
    bin.install asset => "agentplugins"
    chmod 0755, bin/"agentplugins"
  end

  test do
    assert_equal "agentplugins #{{version}}", shell_output("#{{bin}}/agentplugins version").strip
  end
end
'''
Path(sys.argv[2]).write_text(formula)
PY
ruby -c "$FORMULA" >/dev/null

if cmp -s "$FORMULA" Formula/agentplugins.rb; then
  echo "Homebrew formula already matches $TAG"
  exit 0
fi

if [[ "${CHECK_ONLY:-0}" == 1 ]]; then
  diff -u Formula/agentplugins.rb "$FORMULA" || true
  fail "formula does not match $TAG"
fi

cp "$FORMULA" Formula/agentplugins.rb
git config user.name "agentplugins-release"
git config user.email "actions@users.noreply.github.com"
git add Formula/agentplugins.rb
git diff --cached --quiet && fail "formula update produced no staged change"
git commit -m "chore: update agentplugins to $VERSION"
git push origin HEAD:main
echo "Published Formula/agentplugins.rb for $TAG"
