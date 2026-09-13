class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.62"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.62/agentplugins_0.1.62_darwin_arm64", using: :nounzip
      sha256 "fb3ab25a27e6e8dc7a2492bf7f5a64befa472a0f679cc0c69410dcd72ad854a6"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.62/agentplugins_0.1.62_darwin_amd64", using: :nounzip
      sha256 "6eb3be8b0340baa90cb9657f62a640770136dc44f177a591219f1f816560e59e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.62/agentplugins_0.1.62_linux_arm64", using: :nounzip
      sha256 "1a59cfa4ea88532c0e507c1d5cc981d5b927e9fc58474da032771f3372aeed95"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.62/agentplugins_0.1.62_linux_amd64", using: :nounzip
      sha256 "48bb0f7a1aebc82a339b8f8d2593fda0392343606e6d552c582b9465a3a8c1ea"
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
