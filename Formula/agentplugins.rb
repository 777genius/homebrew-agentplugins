class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.90"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.90/agentplugins_0.1.90_darwin_arm64", using: :nounzip
      sha256 "c7b6445d8bfc731d77fc44f7f75b90d2e7ca105559cf63961b13d5af45c32817"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.90/agentplugins_0.1.90_darwin_amd64", using: :nounzip
      sha256 "c079227201f03b2d91e943b29a9494fc8e152b7b881c647381b8d008307a3f1c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.90/agentplugins_0.1.90_linux_arm64", using: :nounzip
      sha256 "04935b710f26c73e18270c7227333ddad7fccc4d93af1c0e4cb2a5c60c82ea23"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.90/agentplugins_0.1.90_linux_amd64", using: :nounzip
      sha256 "8e3d815dd1487ac27a2ee717a9254e179797cf7b7184eb36fbadd5fe209ce4b0"
    end
  end


  resource "third-party-notices" do
    url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.90/THIRD_PARTY_NOTICES.txt", using: :nounzip
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
