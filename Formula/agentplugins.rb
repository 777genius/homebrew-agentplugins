class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.80"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.80/agentplugins_0.1.80_darwin_arm64", using: :nounzip
      sha256 "5ab95cf6f03153621542335e6be361c819d35b2e78643c829a1b413a71977aa0"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.80/agentplugins_0.1.80_darwin_amd64", using: :nounzip
      sha256 "b050a6349d59400ecbce2bdfb193f6f1e09ec046d8374b0504c1e5224ead4fcd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.80/agentplugins_0.1.80_linux_arm64", using: :nounzip
      sha256 "45c3814512e9a1971d35131c23f0b68ab07859b664f6cdc99e4f8dc1f90384ca"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.80/agentplugins_0.1.80_linux_amd64", using: :nounzip
      sha256 "31125cd4ff8815f9c03d1bd62669c9cbac3368c6249fe4e36a35b07db15c6f2b"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.80/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
