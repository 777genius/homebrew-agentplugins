class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.91"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.91/agentplugins_0.1.91_darwin_arm64", using: :nounzip
      sha256 "15cc1cb54e1f60213fb08387031414df0083cfbcfe0b7afc499aa58e69899a9a"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.91/agentplugins_0.1.91_darwin_amd64", using: :nounzip
      sha256 "f494b2c3a77b75a6f32f1da0a346f5dadd37a7e7593506bafaf6c6fd00a5c226"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.91/agentplugins_0.1.91_linux_arm64", using: :nounzip
      sha256 "c16eb9853b192f803ead6ffce112f2322f14f049a04d9473df8e95a77e8fdc56"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.91/agentplugins_0.1.91_linux_amd64", using: :nounzip
      sha256 "7cabae845789bff8691ddfc3888e43a2b66918a6606b2d9b68965c1df58a4626"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.91/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
