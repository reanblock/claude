## Dev Container

Running `claude` in an isolated Docker container is recommended! Use the `claude-code-devcontainer` from [here](https://github.com/reanblock/claude-code-devcontainer)

### Installation

1. Install the prerequistes listed [here](https://github.com/trailofbits/claude-code-devcontainer?tab=readme-ov-file#prerequisites) - which is `docker`, `@devcontainers/cli`, `claude-code-devcontainer `.
2. Update `~/.claude-devcontainer/.claude/settings.json` with all the hooks you want to include (these are mounted in the next step).
3. In each new project you need to run `devc .` once only.
4. Now you can enter the container to start working using `devc shell`.
5. Spin up `claude` and check that it is running with `bypassPermissions` set and the hooks are enabled.

```bash
devc .              Install template + start container in current directory
devc up             Start the devcontainer
devc rebuild        Rebuild container (preserves persistent volumes)
devc down           Stop the container
devc shell          Open zsh shell in container
devc exec CMD       Execute command inside the container
devc upgrade        Upgrade Claude Code in the container
devc mount SRC DST  Add a bind mount (host → container)
devc template DIR   Copy devcontainer files to directory
devc self-install   Install devc to ~/.local/bin
```