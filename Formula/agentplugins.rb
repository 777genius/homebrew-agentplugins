class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.93"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.93/agentplugins_0.1.93_darwin_arm64", using: :nounzip
      sha256 "505296c4bc3a573cf2dc045f074fb6a169fc8a5b50b8f2a188a504fd34770c7e"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.93/agentplugins_0.1.93_darwin_amd64", using: :nounzip
      sha256 "43f06507edcf2f0f5b281bb4e2475db149be271ee3e5aa0d63cc02ef16bc910b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.93/agentplugins_0.1.93_linux_arm64", using: :nounzip
      sha256 "b610de3568c3a9babe8faae039c464f2d98901dc53c014afc7b6b73bdd4e8faf"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.93/agentplugins_0.1.93_linux_amd64", using: :nounzip
      sha256 "af9b9519fa66ff5705f94c6cff20adb3c921acdcc41ed8087ef40f7327a07b50"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.93/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
