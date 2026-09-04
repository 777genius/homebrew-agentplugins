class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.44"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.44/agentplugins_0.1.44_darwin_arm64", using: :nounzip
      sha256 "726c0d810d9b33b782ee2673c81ff2112de5a22fdaca59f590505894434cc896"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.44/agentplugins_0.1.44_darwin_amd64", using: :nounzip
      sha256 "64dd6cd803bf7f4bfa0dfcf3877f2a08a30544b5564c0d301f9c21c902f08101"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.44/agentplugins_0.1.44_linux_arm64", using: :nounzip
      sha256 "871f91fcdfa11c96f5e87adee6cb381e129cb5992d23d481ddea469b534143e3"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.44/agentplugins_0.1.44_linux_amd64", using: :nounzip
      sha256 "2b0a5db0cdbc70bdb1b636cc0b90cee6e6ca547ecc2f3880ec904793d7d51d3c"
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
