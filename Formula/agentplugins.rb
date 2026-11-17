class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.110"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.110/agentplugins_0.1.110_darwin_arm64", using: :nounzip
      sha256 "ca56d6430760bd85c5cf5f1413f628f8bc62603fab4762c64923415c438fb65d"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.110/agentplugins_0.1.110_darwin_amd64", using: :nounzip
      sha256 "8dc2f6850699f3995330f429a98669dc56e2497cf3cdefa1f603a72d190a13ec"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.110/agentplugins_0.1.110_linux_arm64", using: :nounzip
      sha256 "6ed761d8537a08ae7efd167daa57e1329722350f81eb15c2a6b96c03d289c4e9"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.110/agentplugins_0.1.110_linux_amd64", using: :nounzip
      sha256 "be0766016eb980af680e54cd02d6a4cb98f926f2786ed5fa02ffa7dca4360a6e"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.110/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
