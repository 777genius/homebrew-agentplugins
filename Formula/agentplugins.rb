class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.101"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.101/agentplugins_0.1.101_darwin_arm64", using: :nounzip
      sha256 "b2b85de53a9eadccb49e6a97a31fe50dccb8464012509d27462ffbe7d73f956c"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.101/agentplugins_0.1.101_darwin_amd64", using: :nounzip
      sha256 "bf719bc3e19ff3362f6e7efb69298628d7f6e9015534f5a522d5848a077323cc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.101/agentplugins_0.1.101_linux_arm64", using: :nounzip
      sha256 "67f39e771fd4e8f40af783fcdd793cbb63d6ac21b7e83b315749b595bb7f7ee2"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.101/agentplugins_0.1.101_linux_amd64", using: :nounzip
      sha256 "1e4e111efd3589a42a6cbe7e49447451438cb4e830fa30a881ae24d29f0b11d2"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.101/THIRD_PARTY_NOTICES.txt", using: :nounzip
    sha256 "f19bbcef2085b8ec5c11e242130d9218260ad70552a077af0fe2093184c75bfb"
  end

  def install
    asset = Dir["agentplugins_*"].fetch(0)
    bin.install asset => "agentplugins"
    chmod 0755, bin/"agentplugins"
    resource("third-party-notices").stage { prefix.install "THIRD_PARTY_NOTICES.txt" }
  end

  test do
    assert_equal "agentplugins #{version}", shell_output("#{bin}/agentplugins version").strip
  end
end
