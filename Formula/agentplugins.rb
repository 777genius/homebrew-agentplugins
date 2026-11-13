class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.108"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.108/agentplugins_0.1.108_darwin_arm64", using: :nounzip
      sha256 "16cdd897a3b9db3f3c9c104f2ae685dc0ee2512a95a1796118db873d0d114138"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.108/agentplugins_0.1.108_darwin_amd64", using: :nounzip
      sha256 "1bb2c877efe6a26fd4960bbf653776a9991062a297f592a15bd91eee7707c1eb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.108/agentplugins_0.1.108_linux_arm64", using: :nounzip
      sha256 "cb57621f969ee6c2bdef344f2a40091f6708f57b27d15ead98a17f173bfd2b68"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.108/agentplugins_0.1.108_linux_amd64", using: :nounzip
      sha256 "910b5ef653af4f0ed14bd00bb85da14e87d55d60632ff55127303169650d0eeb"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.108/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
