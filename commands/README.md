# Commands

These are custom commands that are explicity invoked using `/`.

NOTE that 'custom commands' can be also known as 'slash commands'. Moreover, commands is also being merged into 'Skills' to that they are essentially the same thing (see section below). The only main difference between Commands and Skills is that Commands are executed explicitly (by prefixing with `/`) and skills are executed based on the discussions being had at the time and are inferred from the from the conversation.

## Examples

- Explore a new codebase command [here](./explore.md). Copy the file to your local `.claude/commands` folder and run using `/explore`.
- Example to create a markdown blog most file [here](./posts/new.md). Copy the `new.md` file to your local `.claude/commands/posts` folder and run using `/posts:new`. Note this example uses a subfolder and command arguments. So you can run like so `/posts:new "My new post" | "A new way to code"` which magically parses the `title` and `description`.

## Links

- Claude Code Tips & Tricks: [Custom Slash Commands](https://cloudartisan.com/posts/2025-04-14-claude-code-tips-slash-commands/)
- Slash Commands [here](https://platform.claude.com/docs/en/agent-sdk/slash-commands)
- Claude Code Tutorial Slash Commands [here](https://www.youtube.com/watch?v=52KBhQqqHuc)
