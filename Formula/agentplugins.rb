class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.86"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.86/agentplugins_0.1.86_darwin_arm64", using: :nounzip
      sha256 "082c8a6f77385f61b5b5a61e2353e3ff7d096158e3e33d3365e54b82e1ef2a95"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.86/agentplugins_0.1.86_darwin_amd64", using: :nounzip
      sha256 "02b5808cdbcbb341833b339ef06c83448c56de037a2a7436f4f2c93bd2535b80"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.86/agentplugins_0.1.86_linux_arm64", using: :nounzip
      sha256 "c3e43eb65fb6a30244ad7c7bcc174f18dd10541db2ba8af1bb399f97628639a4"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.86/agentplugins_0.1.86_linux_amd64", using: :nounzip
      sha256 "ff3e30d082c80e2aed5d50508f3d17cc0a76c69d6e38c5a307687a09f3c18d68"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.86/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
