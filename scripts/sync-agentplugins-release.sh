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
  TAG="$(gh release list --repo "$SOURCE_REPOSITORY" --limit 1000 \
    --json tagName,isDraft,isPrerelease | python3 -c '
import json
import re
import sys

pattern = re.compile(r"^agentplugins-v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$")
candidates = []
for release in json.load(sys.stdin):
    match = pattern.fullmatch(str(release.get("tagName", "")))
    if match and not release.get("isDraft") and not release.get("isPrerelease"):
        candidates.append((tuple(map(int, match.groups())), release["tagName"]))
if not candidates:
    raise SystemExit("no stable Agentplugins release found")
print(max(candidates)[1])
')"
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
# The current standalone CLI uses schema-v2 assets. Keep the paired authoring
# contract below separate; its qualification does not describe this release.
asset_names="$(jq -c '[.assets[].name] | sort' <<<"$release_json")"
if jq -e 'index("THIRD_PARTY_NOTICES.txt") != null' <<<"$asset_names" >/dev/null; then
  jq -e --arg tag "$TAG" '
    .isDraft == false and .isPrerelease == false and .tagName == $tag and
    ([.assets[].name] | sort) == ([
      "checksums.txt", "release-manifest.json", "THIRD_PARTY_NOTICES.txt",
      ($tag | sub("^agentplugins-v"; "agentplugins_") + "_darwin_amd64"),
      ($tag | sub("^agentplugins-v"; "agentplugins_") + "_darwin_arm64"),
      ($tag | sub("^agentplugins-v"; "agentplugins_") + "_linux_amd64"),
      ($tag | sub("^agentplugins-v"; "agentplugins_") + "_linux_arm64"),
      ($tag | sub("^agentplugins-v"; "agentplugins_") + "_windows_amd64.exe"),
      ($tag | sub("^agentplugins-v"; "agentplugins_") + "_windows_arm64.exe")
    ] | sort)
  ' <<<"$release_json" >/dev/null || fail "unexpected standalone release assets"
  gh release download "$TAG" --repo "$SOURCE_REPOSITORY" \
    --pattern release-manifest.json --pattern checksums.txt \
    --pattern THIRD_PARTY_NOTICES.txt --dir "$TEMP_ROOT"
  MANIFEST="$TEMP_ROOT/release-manifest.json"
  python3 - "$TEMP_ROOT" "$TAG" "$VERSION" <<'PY' || fail "invalid standalone release manifest"
import hashlib, json, re, sys
from pathlib import Path
root, tag, version = Path(sys.argv[1]), sys.argv[2], sys.argv[3]
manifest = json.loads((root / "release-manifest.json").read_text())
assert set(manifest) == {"schema_version", "tag", "version", "commit", "assets"}
assert manifest["schema_version"] == 2 and manifest["tag"] == tag and manifest["version"] == version
assert re.fullmatch(r"[0-9a-f]{40}", manifest["commit"])
targets = {"darwin-amd64", "darwin-arm64", "linux-amd64", "linux-arm64", "windows-amd64", "windows-arm64"}
assert set(manifest["assets"]) == targets
checksums = {}
for line in (root / "checksums.txt").read_text().splitlines():
    match = re.fullmatch(r"([0-9a-f]{64})  ([A-Za-z0-9_.-]+)", line)
    assert match and match[2] not in checksums
    checksums[match[2]] = match[1]
expected = {"release-manifest.json", "THIRD_PARTY_NOTICES.txt"}
for target, asset in manifest["assets"].items():
    platform, cpu = target.split("-")
    name = f"agentplugins_{version}_{platform}_{cpu}" + (".exe" if platform == "windows" else "")
    assert set(asset) == {"file", "sha256", "size"} and asset["file"] == name
    assert type(asset["size"]) is int and asset["size"] > 0
    assert re.fullmatch(r"[0-9a-f]{64}", asset["sha256"]) and checksums[name] == asset["sha256"]
    expected.add(name)
assert set(checksums) == expected
for name in ("release-manifest.json", "THIRD_PARTY_NOTICES.txt"):
    assert hashlib.sha256((root / name).read_bytes()).hexdigest() == checksums[name]
PY
  COMMIT="$(jq -r .commit "$MANIFEST")"
  TAG_COMMIT="$(gh api "repos/${SOURCE_REPOSITORY}/commits/${TAG}" --jq .sha)"
  [[ "$TAG_COMMIT" == "$COMMIT" ]] || fail "standalone release tag/source mismatch"
  for file in release-manifest.json checksums.txt THIRD_PARTY_NOTICES.txt; do
    gh attestation verify "$TEMP_ROOT/$file" --repo "$SOURCE_REPOSITORY" \
      --signer-workflow "github.com/${SOURCE_REPOSITORY}/.github/workflows/agentplugins-release.yml" \
      --source-digest "$COMMIT" --cert-oidc-issuer "https://token.actions.githubusercontent.com" \
      --deny-self-hosted-runners >/dev/null || fail "standalone release attestation failed: $file"
  done
else
jq -e --arg tag "$TAG" '
  .isDraft == false and .isPrerelease == false and .tagName == $tag and
  ([.assets[].name] | sort) == ([
    "candidate.json", "checksums.txt", "milestone-a-promotion.json",
    "pair-prepared.json", "release-manifest.json",
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_darwin_amd64"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_darwin_arm64"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_linux_amd64"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_linux_arm64"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_windows_amd64.exe"),
    ($tag | sub("^agentplugins-v"; "agentplugins_") + "_windows_arm64.exe")
  ] | sort)
' <<<"$release_json" >/dev/null || fail "release assets are incomplete or unexpected"

gh release download "$TAG" --repo "$SOURCE_REPOSITORY" \
  --pattern release-manifest.json \
  --pattern milestone-a-promotion.json \
  --pattern checksums.txt \
  --pattern candidate.json \
  --pattern pair-prepared.json \
  --dir "$TEMP_ROOT"
MANIFEST="$TEMP_ROOT/release-manifest.json"
PROMOTION="$TEMP_ROOT/milestone-a-promotion.json"

python3 - "$MANIFEST" "$PROMOTION" "$TEMP_ROOT" "$TAG" "$VERSION" <<'PY' \
  || fail "release manifest or Milestone A promotion record is invalid"
import hashlib
import json
import re
import sys
from pathlib import Path

manifest_path = Path(sys.argv[1])
promotion_path = Path(sys.argv[2])
root = Path(sys.argv[3])
tag, version = sys.argv[4:]
manifest = json.loads(manifest_path.read_text())
promotion = json.loads(promotion_path.read_text())
targets = {
    "darwin-amd64", "darwin-arm64", "linux-amd64", "linux-arm64",
    "windows-amd64", "windows-arm64",
}
sha256 = re.compile(r"[0-9a-f]{64}").fullmatch
commit = re.compile(r"[0-9a-f]{40}").fullmatch

def digest(name):
    return hashlib.sha256((root / name).read_bytes()).hexdigest()

assert manifest["schema_version"] == 3
assert manifest["status"] == "CANDIDATE"
assert manifest["product"] == "agentplugins"
assert manifest["repository"] == "777genius/universal-agent-plugins"
assert manifest["tag"] == tag and manifest["version"] == version
assert commit(manifest["commit"]) and manifest["engine_revision"] == manifest["commit"]
assert manifest["versions"]["agentplugins"] == version
assert re.fullmatch(r"2\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)", manifest["versions"]["plugin-kit-ai"])
assert manifest["authoring_mode"] == "release-cli-contract-v1"
assert manifest["asset_scope"] == "six-platform-pair"
assert manifest["release_eligible"] is False
assert manifest["platform_acceptance"] is False
assert manifest["attested"] is False
assert set(manifest["assets"]) == targets
for target, asset in manifest["assets"].items():
    platform, cpu = target.split("-")
    suffix = ".exe" if platform == "windows" else ""
    assert asset["file"] == f"agentplugins_{version}_{platform}_{cpu}{suffix}"
    assert isinstance(asset["file"], str) and sha256(asset["sha256"])
    assert isinstance(asset["size"], int) and asset["size"] > 0

identity = promotion["identity"]
assert promotion["schema"] == "milestone-a-promotion/v1"
assert identity["repository"] == manifest["repository"]
assert identity["commit"] == manifest["commit"]
assert identity["engine_revision"] == manifest["engine_revision"]
assert identity["versions"] == manifest["versions"]
assert promotion["authoring_mode"] == manifest["authoring_mode"]
assert promotion["asset_scope"] == manifest["asset_scope"]
agent = promotion["products"]["agentplugins"]
kit = promotion["products"]["plugin-kit-ai"]
assert agent["tag"] == tag
assert kit["tag"] == f'plugin-kit-ai-v{identity["versions"]["plugin-kit-ai"]}'
assert agent["assets"] == manifest["assets"]
assert agent["manifest_sha256"] == digest("release-manifest.json")
assert agent["checksums_sha256"] == digest("checksums.txt")
assert promotion["candidate_sha256"] == digest("candidate.json")
assert promotion["pair_marker_sha256"] == digest("pair-prepared.json")
assert promotion["signer"] == {
    "workflow": ".github/workflows/agentplugins-release.yml",
    "source": manifest["commit"],
}
assert promotion["milestone_a"]["workflow"] == ".github/workflows/authoring-milestone-a-e2e.yml"
PY

COMMIT="$(jq -r .commit "$MANIFEST")"
TAG_COMMIT="$(gh api "repos/${SOURCE_REPOSITORY}/commits/${TAG}" --jq .sha)"
[[ "$TAG_COMMIT" == "$COMMIT" ]] || fail "release tag does not match the attested source commit"
gh attestation verify "$MANIFEST" \
  --repo "$SOURCE_REPOSITORY" \
  --signer-workflow "github.com/${SOURCE_REPOSITORY}/.github/workflows/agentplugins-release.yml" \
  --source-digest "$COMMIT" \
  --source-ref "refs/tags/${TAG}" \
  --cert-oidc-issuer "https://token.actions.githubusercontent.com" \
  --deny-self-hosted-runners >/dev/null \
  || fail "release manifest attestation verification failed"
gh attestation verify "$PROMOTION" \
  --repo "$SOURCE_REPOSITORY" \
  --signer-workflow "github.com/${SOURCE_REPOSITORY}/.github/workflows/agentplugins-release.yml" \
  --source-digest "$COMMIT" \
  --source-ref "refs/tags/${TAG}" \
  --cert-oidc-issuer "https://token.actions.githubusercontent.com" \
  --deny-self-hosted-runners >/dev/null \
  || fail "Milestone A promotion attestation verification failed"

fi

FORMULA="$TEMP_ROOT/agentplugins.rb"
python3 - "$MANIFEST" "$FORMULA" "$TEMP_ROOT" <<'PY'
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

notices = ""
notice_file = Path(sys.argv[3]) / "THIRD_PARTY_NOTICES.txt"
if notice_file.is_file():
    import hashlib
    notice_hash = hashlib.sha256(notice_file.read_bytes()).hexdigest()
    notices = f"""
  resource "third-party-notices" do
    url "{base}/THIRD_PARTY_NOTICES.txt", using: :nounzip
    sha256 "{notice_hash}"
  end
"""
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

{notices}
  def install
    asset = Dir["agentplugins_*"].fetch(0)
    bin.install asset => "agentplugins"
    chmod 0755, bin/"agentplugins"
{'    resource("third-party-notices").stage { prefix.install "THIRD_PARTY_NOTICES.txt" }' if notices else ''}
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
git config user.name "iliya"
git config user.email "iliyazelenkog@gmail.com"
export GIT_AUTHOR_NAME=iliya GIT_AUTHOR_EMAIL=iliyazelenkog@gmail.com
export GIT_COMMITTER_NAME=iliya GIT_COMMITTER_EMAIL=iliyazelenkog@gmail.com
git var GIT_AUTHOR_IDENT
git var GIT_COMMITTER_IDENT
git add Formula/agentplugins.rb
git diff --cached --quiet && fail "formula update produced no staged change"
git commit -m "chore: update agentplugins to $VERSION"
git push origin HEAD:main
echo "Published Formula/agentplugins.rb for $TAG"
