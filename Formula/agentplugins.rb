class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.116"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.116/agentplugins_0.1.116_darwin_arm64", using: :nounzip
      sha256 "b25f89153718211b79abe774265d68299346b99a69e478e6b4893425437de425"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.116/agentplugins_0.1.116_darwin_amd64", using: :nounzip
      sha256 "e5073a271b4e7b91d970afc7fb94b93526a4e1044227f81ca37bca596836e67d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.116/agentplugins_0.1.116_linux_arm64", using: :nounzip
      sha256 "7feedc9203fdf1b0b6f3f69d1c68da811fa05165dc7e8852f7c40ae480adde38"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.116/agentplugins_0.1.116_linux_amd64", using: :nounzip
      sha256 "64b0d1193107be51364f994a0b621caa5b8138cc63f7bda38d2714bed7a96bf6"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.116/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
