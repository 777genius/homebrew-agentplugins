class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.102"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.102/agentplugins_0.1.102_darwin_arm64", using: :nounzip
      sha256 "f69d8c0b44db7f768117b5c046339fd9681032f69d4a5b4b9bdeb533fa29b6e9"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.102/agentplugins_0.1.102_darwin_amd64", using: :nounzip
      sha256 "edd88e96c12eeea70e8ca7c29695749e1459dc03bcdbaec63bebfe2ed9a81b7c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.102/agentplugins_0.1.102_linux_arm64", using: :nounzip
      sha256 "e9b6f599d2d5a469b9420648d707230c584979be1a41cc7680925c5ee173c0a3"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.102/agentplugins_0.1.102_linux_amd64", using: :nounzip
      sha256 "3ccfead44b8d539fd577bfc5b142a75dbec3f33b018123ac59ca40cb89522983"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.102/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
