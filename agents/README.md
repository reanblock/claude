## Agent Teams

### Steps

**Greenfield Project (brand new)**

1. Create new project directory `calorie-tracker-app` and cd into it then run `git init`.
2. Run `tmux`.
3. Run `claude`.
4. Run `/plan_w_team` with your project spec prompt and team orchestration prompt (useing the prompt we created earlier).
5. Review `specs/<plan>.md` — tweak if needed.
6. Run `/build-with-agent-team` skill for example `/build-with-agent-team specs/<plan>.md`.

**Brownfield Project (adding new feature)**

1. Run `/explore` skill to get a summary of the project. 

**Example /plan_w_team user and orchestration promopt**

```bash
/plan_w_team "Build a simple calorie tracker web app. Users should be able to:
- Add food entries with a name and calorie count
- View a daily log of all entries
- See a running total for the day
- Delete entries
- Reset/clear the day

Use plain HTML, CSS, and vanilla JavaScript with a JSON file as the data store. No frameworks, no build tools. Keep it simple and self-contained." 

"Use two builder agents running in parallel: one focused on the data layer (storage, read/write operations, daily totals logic) and one focused on the UI (HTML structure, CSS styling, user interactions). The data builder should use Opus. The UI builder should use Sonnet. Both builders work simultaneously. Once both are complete, use the tester agent to write and run tests covering happy paths, edge cases, and failure scenarios. Keep at least one builder agent available to fix things should any tests fail. Finally, use the validator agent to wire everything together and verify the app meets all acceptance criteria end-to-end."
```

The above task chain is:

builder-data ─┐
              ├──> tester ──> validator
builder-ui  ──┘

The two builders are parallel, then tester and validator are sequential gates after both finish.

NOTE: Currently an experimental feature - you need to add the following to your `settings.json`:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### Tmux

Use iTerm (or tmux) to view agents working in split panes.

Install and start tmux session:

```bash
brew install tmux
tmux new
cd my-project
claude --dangerously-skip-permissions
```

Try this prompt in the tmux session (remember to have `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` enabled)

```
I want to build a Global Tide & Sea Temperature web app. Create an Agent Team with 3 specific teammates to work in parallel:

1. Backend_Dev: Focus on integrating the Global Tide API and Sea Temps.
2. Frontend_Dev: Build a responsive, dark-mode web UI that visualizes this data.
3. The_Skeptic: A security and UX researcher who plays 'Devil's Advocate'

Follow these rules:

1. Require plan approval for Backend_Dev and Frontend_Dev before they write any code.
2. The_Skeptic should not write code, only review plans and docs.
3. All teammates must update CLAUDE.md with their decisions.
```

You should see something amazing like:

![Multi-Agent Teams](../images/multi-agent-teams.png)

### Orchestration using the Multi-Agent Observability Application

1. Clone the `claude-code-hooks-multi-agent-observability` repo [here](https://github.com/disler/claude-code-hooks-multi-agent-observability)
2. Follow the Integration steps [here](https://github.com/disler/claude-code-hooks-multi-agent-observability?tab=readme-ov-file#-integration)
3. Install `bun` [here](https://bun.sh/) and reload your environment using `source`.
4. Install `vite` [here](https://vite.dev/) by navigating to `apps/client` and running `bun install`.
5. Start the `./scripts/start-system.sh` script to start the Observability server.
6. Run a test using the provided `curl` example. The event should display in the Multi-Agent Observability app.
7. Run `claude` in the project where you copied the .claude files.

### Examples

- Spin up 4 agents to run a [parallel PR review](https://code.claude.com/docs/en/agent-teams#run-a-parallel-code-review) from different lenses: security, test coverage, performance imapaact and feature correctness.
- Spin up multiple agents to work on a [debuging problem](https://code.claude.com/docs/en/agent-teams#investigate-with-competing-hypotheses), each one can focus on different hypotheses and test out each case: one checks if it is a datbase issue, another checks if it is a server issue etc.
- Spin up multiple agents to build an MVP application: one on UI, one on DB, one on API, one on testing etc.

### Links

- Claude Code Multi-Agent Orchestration with Opus 4.6, Tmux and Agent Sandboxes [here](https://www.youtube.com/watch?v=RpUTF_U4kiw)
- Claude Code Agent Teams (Full Tutorial) [here](https://www.youtube.com/watch?v=zm-BBZIAJ0c)
- Claude Opus 4.6: Agent Teams Change Everything! [here](https://www.youtube.com/watch?v=RWDK5414yL4)