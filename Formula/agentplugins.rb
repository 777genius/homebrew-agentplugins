class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.63"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.63/agentplugins_0.1.63_darwin_arm64", using: :nounzip
      sha256 "fef8d3039e66ac263740f83048fb00cb2cba31b18decb4019bef0c7b113f565c"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.63/agentplugins_0.1.63_darwin_amd64", using: :nounzip
      sha256 "94bb367d0d60c77dca8e4919757ba4c59f5ae90e9d1c66e06f5a2eddc436f516"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.63/agentplugins_0.1.63_linux_arm64", using: :nounzip
      sha256 "a966ee2a6fef8833852e5e3cc7242a83fabeb36801db13f1204b33ec49835c37"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.63/agentplugins_0.1.63_linux_amd64", using: :nounzip
      sha256 "ad351d3d2cad34bcb560b10bc8c87af29286a61f06f81a52b2f262d7de4945cd"
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
