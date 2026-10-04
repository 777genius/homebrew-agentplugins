class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.74"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.74/agentplugins_0.1.74_darwin_arm64", using: :nounzip
      sha256 "3d4c7f6b110e28d4f633b2522b17132a4672a1f3ebf6e1c5d27c8f7fabeeeb4b"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.74/agentplugins_0.1.74_darwin_amd64", using: :nounzip
      sha256 "b7852be3bfced4f158ba2ec4170e61758ee439dcb2a16f54307cc14977b1321d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.74/agentplugins_0.1.74_linux_arm64", using: :nounzip
      sha256 "586dffef205ecc5f4cd6de25b5f244d19c462ab4a823ddcc989302bf90db5689"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.74/agentplugins_0.1.74_linux_amd64", using: :nounzip
      sha256 "c4ae2540608ef8899800d7620fd7ca45e71d0875022a04f90ea496940114715e"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.74/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
