class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.65"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.65/agentplugins_0.1.65_darwin_arm64", using: :nounzip
      sha256 "c75c796293564d14a7a54db976b49f7b8714cc2bf245de3b0e7499c3b07c867d"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.65/agentplugins_0.1.65_darwin_amd64", using: :nounzip
      sha256 "4d38d70ac19aba27fd328bd44a6fbcfd0d3be36a3ad05ce7d404d317bda53471"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.65/agentplugins_0.1.65_linux_arm64", using: :nounzip
      sha256 "f7a1b0035938da2c8a086b31762aa14b3582c3083a90ce685d0be46fde8b5980"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.65/agentplugins_0.1.65_linux_amd64", using: :nounzip
      sha256 "607d24dc7a45f3d07b23265b092c7b92cecc79aaeeabea15641f40e156112f37"
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
