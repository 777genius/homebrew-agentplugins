class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.78"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.78/agentplugins_0.1.78_darwin_arm64", using: :nounzip
      sha256 "793634928d1338ad074ab18a98c44bd61fa776a921bc3ddf34038414ff15b785"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.78/agentplugins_0.1.78_darwin_amd64", using: :nounzip
      sha256 "a5368a3b211e46dc82c1f9450059b3c724608b48474c7f91f917bbc31b45eb5e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.78/agentplugins_0.1.78_linux_arm64", using: :nounzip
      sha256 "11bd8341da042eefe07cc5bca50c0ce465d22bcfc7d2e01d3ce980607b530076"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.78/agentplugins_0.1.78_linux_amd64", using: :nounzip
      sha256 "f67205164bdd72cb81a738c3ee0e1c63a39027b61cc5dd85b15481e0352af6c6"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.78/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
