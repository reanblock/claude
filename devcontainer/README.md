## Dev Container

Running `claude` in an isolated Docker container is recommended! Use the `claude-code-devcontainer` from ToB [here](https://github.com/trailofbits/claude-code-devcontainer)

### Installation

1. Install the prerequistes listed [here](https://github.com/trailofbits/claude-code-devcontainer?tab=readme-ov-file#prerequisites) - which is `docker`, `@devcontainers/cli`, `claude-code-devcontainer `.
2. Update `~/.claude-devcontainer/.claude/settings.json` with all the hooks you want to include (these are mounted in the next step).
4. [OPTIONAL] NOTE: this *might* have an error related to `bun` dependency. You need to update the approach that claude is installed as it might error. Replace the `claude` install with this:
  ```bash
    # Install Claude Code via npm
    RUN export PATH="$FNM_DIR:$PATH" && \
      eval "$(fnm env)" && \
      npm install -g @anthropic-ai/claude-code
  ```
3. In each new project you need to run `devc .` once only.
1. Add this to the project `.devcontainer/devcontainer.json` file under the `mounts` key `"source=${localEnv:HOME}/.claude/hooks,target=/home/vscode/.claude/hooks,type=bind,consistency=cached"`  and rebuild the conatiner using `devc rebuild`.
2. Now you can enter the container to start working using `devc shell`.
3. Spin up `claude` and check that it is running with `bypassPermissions` set and the hooks are enabled.

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