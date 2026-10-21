class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.89"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.89/agentplugins_0.1.89_darwin_arm64", using: :nounzip
      sha256 "a7ea3f90bc4fc049fad6ff158b4ad8db1c40e50f6b415ebec08d56063bf157fa"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.89/agentplugins_0.1.89_darwin_amd64", using: :nounzip
      sha256 "e3fde5201776e34a06423765fe99b8fa8779626cbf246a8a85b68fe4e37aa2fe"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.89/agentplugins_0.1.89_linux_arm64", using: :nounzip
      sha256 "cc8837921d06794ea70df3597a795b9ec30119e27f03dadbb55beddafc2867f7"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.89/agentplugins_0.1.89_linux_amd64", using: :nounzip
      sha256 "41bb941b8cd583588759748ad77d01f0a3ad015a779231ed1dd5e0c7f40a6134"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.89/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
