class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.81"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.81/agentplugins_0.1.81_darwin_arm64", using: :nounzip
      sha256 "ed85af067b4780746b0ec178ef5a56fe8a813343a344a8c31d1e82276ee83a02"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.81/agentplugins_0.1.81_darwin_amd64", using: :nounzip
      sha256 "3836a1ade2c80fddfc5f82d1663dfe814effe8c60a2bc1be366a02d71a17a02e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.81/agentplugins_0.1.81_linux_arm64", using: :nounzip
      sha256 "9e1d3cab8f1a2a6ed5e66f00fd3073517766f6173d66218e02474d501bb7ec4e"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.81/agentplugins_0.1.81_linux_amd64", using: :nounzip
      sha256 "d74c432958f89fda6b8582ff39c6459d1cc532b69f35fe463066243c1918a73f"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.81/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
