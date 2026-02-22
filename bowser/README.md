## Bowser

For more details refer to [claude-bowser](https://github.com/reanblock/claude-bowser) repo. Video [here](https://www.youtube.com/watch?v=efctPj6bjCY).

## Playwright

Use playwrite for automating UI/UX tests, integrations, user stories, qa testing. Can be part of a CI/CD or development workflow.

### Setup in project

For any project, to incorporate automated UI/UX testing using "Claude Bowser" setup as follows:

1. Install everything on local using `./install.sh`
2. Create a folder for user stories testing `mkdir -p ai_review/user_stories`
3. Add user stories for your project in the `ai_review/user_stories` folder. For example, [hackernews.yaml](/ai_review/user_stories/hackernews.yaml). Create as many user stories as required! TIP: for your own project get claude to create a new user stories file.
4. Add a new `justfile` to the root of the project. For example, [justfile](../justfile). Update as required.

### Try It Now!

This repo already has a `justfile` and an example set of user stories for running the `ui-review` task. To test this you can:

1. Clone the `claude-code-kit` repo (this one!).
2. Install everything on local using `./install.sh`.
3. Install just `brew install just`.
4. Run `just ui-review` (this will run the [hackernews.yaml](/ai_review/user_stories/hackernews.yaml) user stories using a headed playwright skill.

## Chrome

Use Chrome for running personal tasks. This requires the Claude extention in Chrome and to start claude using `--chrome` flag. Its not really a 'project specific' task.

### Try It Now!

This repo already has a `justfile` and an example set of user stories for running the `test-chrome-skill` task. To test this you can:

1. Clone the `claude-code-kit` repo (this one!).
2. Install everything on local using `./install.sh`.
3. Install just `brew install just`.
4. Install Chrome Browser.
5. Install the Claude Extention and enable it.
6. Log into Claude (claude.ai) in Chrome browser using the same account as you have for Claude Code.
7. Run `just test-chrome-skill`. This will run the `default_chrome_prompt` which will open your calendar in Chrome browser and list out the meetings you have booked for the next 5 days.