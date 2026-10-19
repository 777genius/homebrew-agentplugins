class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.87"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.87/agentplugins_0.1.87_darwin_arm64", using: :nounzip
      sha256 "5999d134cdd5a32963e614a628ee87394aa98de7da9428650b05518d878f27ec"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.87/agentplugins_0.1.87_darwin_amd64", using: :nounzip
      sha256 "2ab7524e7b3db05a29ea36858fd047ab293d7d613f28a2da6236841e8cb2eac4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.87/agentplugins_0.1.87_linux_arm64", using: :nounzip
      sha256 "d91542ca22f8fadb4e2fbb950a834a29ba7255b47ce33b0d39b650f186e35b21"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.87/agentplugins_0.1.87_linux_amd64", using: :nounzip
      sha256 "6940f3fa1877e9b7327c3ed3a43dde92b2725c5ce6bd1a8c5216bf17bfa06e70"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.87/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
