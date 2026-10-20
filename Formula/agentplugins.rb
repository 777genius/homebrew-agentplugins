class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.88"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.88/agentplugins_0.1.88_darwin_arm64", using: :nounzip
      sha256 "6b408e3ca4418d6300799266b4ccddbb84550ec60a7268c4260f6b730163a3f4"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.88/agentplugins_0.1.88_darwin_amd64", using: :nounzip
      sha256 "ca7e44d7e93375293649756f2bbd853fa668f13a101fad85258254fb62b9477c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.88/agentplugins_0.1.88_linux_arm64", using: :nounzip
      sha256 "4a6faf7f90a23802e15de23f219ac04742cf39a97f83344da6423a7511c04696"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.88/agentplugins_0.1.88_linux_amd64", using: :nounzip
      sha256 "c4a315480a95b1825225ac1e001f2ee1af8c1e44133e5b5d5e11b8341d7407d6"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.88/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
