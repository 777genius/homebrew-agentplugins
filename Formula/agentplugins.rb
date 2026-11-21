class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.115"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.115/agentplugins_0.1.115_darwin_arm64", using: :nounzip
      sha256 "59223e1e051297607440f4ec9a6a11eab24aac1ae0c1da5a9b6d87035af9947f"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.115/agentplugins_0.1.115_darwin_amd64", using: :nounzip
      sha256 "a63c9be3c7e29d291daa01c282ce8400a6e956000c2ad3a79bb389b8910cc6fd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.115/agentplugins_0.1.115_linux_arm64", using: :nounzip
      sha256 "4692f4f377c704e9c16ee3720f0c3e2181e3ceffe290b66b99758d3f6ca7dcbf"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.115/agentplugins_0.1.115_linux_amd64", using: :nounzip
      sha256 "9a501a32358889770aef64e7aab246527a6036419ea74724f9dfd3a48db1c119"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.115/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
