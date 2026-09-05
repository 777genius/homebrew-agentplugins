class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.50"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.50/agentplugins_0.1.50_darwin_arm64", using: :nounzip
      sha256 "45d43d6e844743f51c5ef350a1d3bfbd94e787e1ea4b8a502f4db3b328fd77e1"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.50/agentplugins_0.1.50_darwin_amd64", using: :nounzip
      sha256 "b9733df1c47252d71fe885fd4f0c6a3fa7db019a8f2ee57232a320e1b72904f1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.50/agentplugins_0.1.50_linux_arm64", using: :nounzip
      sha256 "f899d567c29ba8edbf1c708a1290cd6e7f1845af7e172902c3bad4843205557a"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.50/agentplugins_0.1.50_linux_amd64", using: :nounzip
      sha256 "6c1362efd0fa57f459eb4728f14fb764adf1686520e67c4da05a9cf7e6062309"
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
