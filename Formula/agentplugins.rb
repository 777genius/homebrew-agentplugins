class Agentplugins < Formula
  desc "Universal installer and lifecycle manager for Agent Plugins 1.0"
  homepage "https://github.com/777genius/universal-agent-plugins"
  version "0.1.46"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.46/agentplugins_0.1.46_darwin_arm64", using: :nounzip
      sha256 "f7d8f00a5cfae6b3ff9f2cdd96be30fb72e2289bc4a0fc3bbd6da99084ecd584"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.46/agentplugins_0.1.46_darwin_amd64", using: :nounzip
      sha256 "2e7a4a8e7fb2dc39618d2ffd983235666ce2158c01ce2757208514d9ea86a43c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.46/agentplugins_0.1.46_linux_arm64", using: :nounzip
      sha256 "5be8e4c882d8a32c294af80154bbf99a4da92c9b3aebf8b65b0a3739d68e5eee"
    else
      url "https://github.com/777genius/universal-agent-plugins/releases/download/agentplugins-v0.1.46/agentplugins_0.1.46_linux_amd64", using: :nounzip
      sha256 "8d5c9f079bf76e479359a0e1f3464a35d68d756197f576347ef54a0d06168f70"
    end
  end

  def install
    asset = Dir["agentplugins_*"].fetch(0)
    bin.install asset => "agentplugins"
    chmod 0755, bin/"agentplugins"
  end

  test do
    assert_equal "agentplugins #{version}", shell_output("#{bin}/agentplugins version").strip
  end
end
