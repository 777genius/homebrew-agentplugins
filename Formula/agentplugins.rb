class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.45"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.45/agentplugins_0.1.45_darwin_arm64", using: :nounzip
      sha256 "d6a842da8a96288b4496e89c50ab873b2393b4ce75edb2c6dbf05db3c0726267"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.45/agentplugins_0.1.45_darwin_amd64", using: :nounzip
      sha256 "6f20d20f8560f86555455328a1af7d8a30c5be231208d5f681dfd5e1d606178d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.45/agentplugins_0.1.45_linux_arm64", using: :nounzip
      sha256 "f5c4b2dca163c7c2ae39e2ac21b273dce311056777308d5cee2695303c00d051"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.45/agentplugins_0.1.45_linux_amd64", using: :nounzip
      sha256 "464e8aef298be91bf2ec006d7766d15c8a4e58f749a7f3a6adbe9f7cf7854837"
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
