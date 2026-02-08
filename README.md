# Claude

## Background

In this repo, we explore Claude Code features, in particular:

| Feature | Type | Example Use Cases |
|---|---|---|
| Skills | Automatic behaviors | Automatically extract text and data from PDFs, Detect style guide violations |
| MCP | External integrations | Connect to Jira instance for tickets, Query PostgreSQL database for reports, Fetch real-time weather data from APIs |
| Commands | Manual triggers | Create React components from template, Generate standardized git commit messages, Run comprehensive security audits |
| Subagents | Isolated workflows | Debug failing test suites, Perform parallel code quality analysis |

## Basics

Below are some basics such as getting started, installation, CLI reference, different modes, and initiating a project.

- CLI reference [here](https://code.claude.com/docs/en/cli-reference)
- Plan Mode (shift+tab) [here](https://claudelog.com/mechanics/plan-mode/)
- Interactive Mode [here](https://code.claude.com/docs/en/interactive-mode#general-controls)
- Checkpointing [here](https://code.claude.com/docs/en/checkpointing)
- Use `plan` mode when starting new projects (toggle using tab+shift)
- Create a CLAUDE.md (and associated) files for context loading. Use [this prompt](./prompts/claude-md-prompt.txt).

## Commands

These are custom commands that are explicity invoked using `/`.  

NOTE that 'custom commands' can be also known as 'slash commands'. Moreover, commands is also being merged into 'Skills' to that they are essentially the same thing (see section below). The only main difference between Commands and Skills is that Commands are executed explicitly (by prefixing with `/`) and skills are executed based on the discussions being had at the time and are inferred from the from the conversation.

### Examples

- Explore a new codebase command [here](./commands/explore.md). Copy the file to your local `.claude/commands` folder and run using `/explore`.
- Example to create a markdown blog most file [here](/commands/posts/new.md). Copy the `new.md` file to your local `.claude/commands/posts` folder and run using `/posts:new`. Note this example uses a subfolder and command arguments. So you can run like so `/posts:new "My new post" | "A new way to code"` which magically parses the `title` and `description`.

### Links

- Claude Code Tips & Tricks: [Custom Slash Commands](https://cloudartisan.com/posts/2025-04-14-claude-code-tips-slash-commands/)
- Slash Commands [here](https://platform.claude.com/docs/en/agent-sdk/slash-commands)
- Claude Code Tutorial Slash Commands [here](https://www.youtube.com/watch?v=52KBhQqqHuc)

## Skills

Skills are markdown files that provide Claude a set of instructions to perform a specific task. You can get Claude to create a new skill by simply asking it to! Remember to ask the question "What else should I clarify?" after sharing all the details about your new skill.

**NOTE**: Claude Desktop ships with the `skill-creator` skill enabled (under Settings -> Capabilities -> Skills). 

The skill must be placed in the following folder structure: `.claude/skills/<skill-name>/SKILL.md`.

### Install

Use [skills.sh](https://skills.sh/) e.g. `npx skills add anthropics/skills` (replace 'anthropics/skills' with the skills marketplace repo you want) and then follow instructions.

Alternativly, follow instructions [here](https://github.com/anthropics/skills?tab=readme-ov-file#claude-code).

**NOTE**: This uses 'Plugins' for installing the skills and can be found in `~/.claude/plugins/marketplaces/claude-plugins-official` for example.

### Examples

- Security Audit Report Severity Reviewer Skill [here](./skills/severity-review/SKILL.md)
- Explain Code Skill [here](./skills/explain-code/SKILL.md) (taken from docs [here](https://code.claude.com/docs/en/skills))

### Links

- Claude Skills Docs [here](https://code.claude.com/docs/en/skills#extend-claude-with-skills)
- Anthropics official skills repo [here(]https://github.com/anthropics/skills)
- Agent Skills Standard Open Format [here](https://agentskills.io/)
- skills.sh install utility [here](https://skills.sh/)
- Complete Skills Guide [here](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf?hsLang=en)
- Claude Skills Explained - Step-by-Step Tutorial for Beginners [here](https://www.youtube.com/watch?v=wO8EboopboU)
- 

## MCP

External integrations to provide Claude access to new tools, serviecsn, APIs etc.

### Links

- Chrome DevToops MCP [here](https://github.com/ChromeDevTools/chrome-devtools-mcp)
- Playwright MCP [here](https://github.com/microsoft/playwright-mcp)
- Vercel MCP [here](https://vercel.com/docs/ai-resources/vercel-mcp)
- Context7 MCP [here](https://github.com/upstash/context7)
- Repomix MCP [here](https://repomix.com/guide/)

## Agents

**TODO**

## Plugins

**TODO**

## Links

- [Edmund's Claude Code Setup](https://github.com/edmund-io/edmunds-claude-code)
- [Vibe Coding Academy](https://www.vibecodingacademy.ai/)
- [Claude AI Developer Guide](https://claudeai.dev/)