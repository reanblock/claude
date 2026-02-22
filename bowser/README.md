## Bowser

For more details refer to [claude-bowser](https://github.com/reanblock/claude-bowser) repo. Video [here](https://www.youtube.com/watch?v=efctPj6bjCY).

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