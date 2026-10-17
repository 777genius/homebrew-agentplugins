class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.84"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.84/agentplugins_0.1.84_darwin_arm64", using: :nounzip
      sha256 "69123b647b6b097651dde0e06eb652df420dcecd0b210a4e640ea91a5e6cb3d5"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.84/agentplugins_0.1.84_darwin_amd64", using: :nounzip
      sha256 "1366bf7c2ac3546a1b52e5bd948a3eb9630a5796d7b9ac2c0c606cf4cbfc0093"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.84/agentplugins_0.1.84_linux_arm64", using: :nounzip
      sha256 "575050ef4929a0d67e4c4e2cc5f7d91e9a67413321c499080e26ffb6da5a8e32"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.84/agentplugins_0.1.84_linux_amd64", using: :nounzip
      sha256 "8d5a55ea6ec35fcca9af7fa700bfec8df11e811206984640b03199624baab530"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.84/THIRD_PARTY_NOTICES.txt", using: :nounzip
    sha256 "f19bbcef2085b8ec5c11e242130d9218260ad70552a077af0fe2093184c75bfb"
  end

  def install
    asset = Dir["agentplugins_*"].fetch(0)
    bin.install asset => "agentplugins"
    chmod 0755, bin/"agentplugins"
    resource("third-party-notices").stage { prefix.install "THIRD_PARTY_NOTICES.txt" }
  end

  test do
    assert_equal "agentplugins #{version}", shell_output("#{bin}/agentplugins version").strip
  end
end
