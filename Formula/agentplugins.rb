class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.53"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.53/agentplugins_0.1.53_darwin_arm64", using: :nounzip
      sha256 "7bc16e2183786963803fb83f1e5a351615362f49c578d174611293859fa12cd0"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.53/agentplugins_0.1.53_darwin_amd64", using: :nounzip
      sha256 "69175d1a4abf4de9fa96c2fc9a373cdaac4b7d3b9ad1b458f71560aaa638567f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.53/agentplugins_0.1.53_linux_arm64", using: :nounzip
      sha256 "f33a5b72a53d503416e573f0fae8cef7d5193f48edd2cfe4bcf8e36c3e57fb99"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.53/agentplugins_0.1.53_linux_amd64", using: :nounzip
      sha256 "d9d1a99a6d0d5e497bad793df017efc8e59a1e53c4012e6375ade6a3d12c3df9"
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
