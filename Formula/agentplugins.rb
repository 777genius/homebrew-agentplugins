class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.104"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.104/agentplugins_0.1.104_darwin_arm64", using: :nounzip
      sha256 "31a3ead74dfb2e7d00d582332c5360e008fc6357b55643f49943042b2e222724"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.104/agentplugins_0.1.104_darwin_amd64", using: :nounzip
      sha256 "0ae023717a4f18e67abb89f82d9ac779f17a3a9d35f1dbd8a9b94052014cd949"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.104/agentplugins_0.1.104_linux_arm64", using: :nounzip
      sha256 "7cdb7ea490bf15c061658d46e176b1b348ee7a4ac77e7913769771fba6dda992"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.104/agentplugins_0.1.104_linux_amd64", using: :nounzip
      sha256 "043c3f2d66a578239204f3bebaaf4d7eaab1a70b8f0be08f4e2cda03e8443e01"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.104/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
