class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.49"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.49/agentplugins_0.1.49_darwin_arm64", using: :nounzip
      sha256 "da98641532f5a34138c5ea6ad36dfb00f72ecbe4f6b3b6ae6ab3a61368899d78"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.49/agentplugins_0.1.49_darwin_amd64", using: :nounzip
      sha256 "41fef3a91af1a62482c76b2beb512c1a2a71fff9b4346eaf08199fc8f86f07bc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.49/agentplugins_0.1.49_linux_arm64", using: :nounzip
      sha256 "b31b88efbab6c4057ef353669826d9841a45eab583e1c8662b281b2eec60f9dc"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.49/agentplugins_0.1.49_linux_amd64", using: :nounzip
      sha256 "aeff52fce6e96574c34f0feea19c5329f0bb274ea5d4d55eb13dc49b4caa6edf"
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
