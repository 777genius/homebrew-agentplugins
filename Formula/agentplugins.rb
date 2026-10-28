class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.94"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.94/agentplugins_0.1.94_darwin_arm64", using: :nounzip
      sha256 "532ac1f4faaf3a72816286fa84ba62051d612f1f654e4121e6f5c04151562ca8"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.94/agentplugins_0.1.94_darwin_amd64", using: :nounzip
      sha256 "7f9e0fc5565f82d49cb00dd93768bb1167aa0aabd0414335b696cb439fedfab6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.94/agentplugins_0.1.94_linux_arm64", using: :nounzip
      sha256 "e7a264b02e06e96c3e0bd91110b7d8c6cb433d75abff5fb862c97d1583157b2a"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.94/agentplugins_0.1.94_linux_amd64", using: :nounzip
      sha256 "ceae4c92be86f895c1c49efff80021fe631d57e24c41de4daca9fe53beadd1d2"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.94/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
