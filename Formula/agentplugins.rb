class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.64"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.64/agentplugins_0.1.64_darwin_arm64", using: :nounzip
      sha256 "a464f97fdf76d512548a940f517ee424bbee373c3233bcb20ceb83ed479048bd"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.64/agentplugins_0.1.64_darwin_amd64", using: :nounzip
      sha256 "2273e0807880fb0a0f238592e87f4ebf03cd6e4aacf3995a95ac49adf158bc1d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.64/agentplugins_0.1.64_linux_arm64", using: :nounzip
      sha256 "5dbb9218260278e69ab1f2f3f0c6d2fbc175a2ee3bf9c312655391e293be4d96"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.64/agentplugins_0.1.64_linux_amd64", using: :nounzip
      sha256 "07e373a0b707dd882c746ee5f214bc0a78d36b7a92bae79310067f66b3e080a2"
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
