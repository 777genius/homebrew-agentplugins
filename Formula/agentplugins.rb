class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.111"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.111/agentplugins_0.1.111_darwin_arm64", using: :nounzip
      sha256 "073ee4750498fee78f3d4a40002779c11012c36e9812ba781b9136f54f862548"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.111/agentplugins_0.1.111_darwin_amd64", using: :nounzip
      sha256 "4eac7cc18243b15ffb0b1c066add6d317e5a96381104f9d5dcbe5224345446df"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.111/agentplugins_0.1.111_linux_arm64", using: :nounzip
      sha256 "1b9ddc06517cc2439909a23c1987037cc2acf22946d68734de7d1f1fdecaa90e"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.111/agentplugins_0.1.111_linux_amd64", using: :nounzip
      sha256 "ec282e66551269ce69daa1e5d9090dc1ec0de87e63abbfceb66c3589eb6ad40f"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.111/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
