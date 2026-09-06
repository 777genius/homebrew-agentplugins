class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.51"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.51/agentplugins_0.1.51_darwin_arm64", using: :nounzip
      sha256 "8cf87962c8e59791cdc47c9156aacd8d6b23b3ffc9bc17ba8c4353c74cce278a"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.51/agentplugins_0.1.51_darwin_amd64", using: :nounzip
      sha256 "684ab84e621a222973c5b8efc4a86e63d0d7f56be86b6ee9022d5df10a3200ec"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.51/agentplugins_0.1.51_linux_arm64", using: :nounzip
      sha256 "9fd17c2a7b11cea1e6166af5e5758880d9257808de3ce6f75a8414dfab210cd9"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.51/agentplugins_0.1.51_linux_amd64", using: :nounzip
      sha256 "bc2b5e546394eb176eebd97226972eec9c60f8f1518bc7981ead6ea752c57a53"
    end
  end

  def install
    asset = Dir["agentplugins_*"].fetch(0)
    bin.install asset => "agentplugins"
    chmod 0755, bin/"agentplugins"
  end

  test do
    assert_equal "agentplugins #{version}", shell_output("#{bin}/agentplugins version").strip
  end
end
