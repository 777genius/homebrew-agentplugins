# Agentplugins Homebrew tap

Install the native [Universal Agent Plugins](https://github.com/777genius/universal-agent-plugins)
CLI on macOS or Linux without Node.js:

```bash
brew install 777genius/agentplugins/agentplugins
agentplugins add context7
```

Update or remove it with normal Homebrew commands:

```bash
brew upgrade agentplugins
brew uninstall agentplugins
```

The formula is generated from an attested Universal Agent Plugins release and
pins every platform binary by SHA-256. Do not edit generated formula versions
by hand; release automation updates them after a new native release succeeds.

Licensed under Apache 2.0. Plugin runtimes may declare their own dependencies
even though the `agentplugins` manager itself does not require Node.js.
