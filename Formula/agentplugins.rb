class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.83"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.83/agentplugins_0.1.83_darwin_arm64", using: :nounzip
      sha256 "6cf09517311005c85381c48ee40fb8792c72745af544554b49cc6202e40440dd"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.83/agentplugins_0.1.83_darwin_amd64", using: :nounzip
      sha256 "dc98fef2069044524e549b1f36466c2973fedcd70da9ef4620798fca5828a1ca"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.83/agentplugins_0.1.83_linux_arm64", using: :nounzip
      sha256 "410d1e7b4c30357c48bd1b6a61fa0911bb68d886126ddced6c863e81726373d2"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.83/agentplugins_0.1.83_linux_amd64", using: :nounzip
      sha256 "51a559893df55682b7c77290f1ef8eeeb823fa8d056493ea40a3c73f2f0f6a22"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.83/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
