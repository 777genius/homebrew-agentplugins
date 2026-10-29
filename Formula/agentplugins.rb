class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.95"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.95/agentplugins_0.1.95_darwin_arm64", using: :nounzip
      sha256 "d73dee8f45df8c45cf260f52a37be0e5e2e98aa41e42fd3cbe91fce585f3b621"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.95/agentplugins_0.1.95_darwin_amd64", using: :nounzip
      sha256 "2d6654115423097af4ed07f33dd9ca94c728357c82098f4d4af0ff8bc82ff7c8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.95/agentplugins_0.1.95_linux_arm64", using: :nounzip
      sha256 "0f3bf50ec4478f53b92e41a49cbbf96745ad68248d860e4dbe7293a483180f99"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.95/agentplugins_0.1.95_linux_amd64", using: :nounzip
      sha256 "af5c1891b27b1707c657f677168dd0495ec8b9fe18db1385dbfa448147b6e9b6"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.95/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
