class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.114"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.114/agentplugins_0.1.114_darwin_arm64", using: :nounzip
      sha256 "b723467f64dbdf1b56a171324d8545bc51d9f6c954839c467011e78ce6fc38de"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.114/agentplugins_0.1.114_darwin_amd64", using: :nounzip
      sha256 "62448a162641de8c95c6ab6cad40319ef731eb94bb64e5fbbcef035b8c311e08"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.114/agentplugins_0.1.114_linux_arm64", using: :nounzip
      sha256 "76078eb69f9f7d011e34c17f58c612c0117e0ac5a79e054621c32e226ce318a1"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.114/agentplugins_0.1.114_linux_amd64", using: :nounzip
      sha256 "6994e4d79414c64439aa57acabf001621b2b01d6dfa37fd9d6801f72d3e0a3eb"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.114/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
