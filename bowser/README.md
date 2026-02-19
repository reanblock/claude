## Bowser

For more details refer to [claude-bowser](https://github.com/reanblock/claude-bowser) repo.

### Setup in project

For any project, to incorporate automated UI/UX testing using "Claude Bowser" setup as follows:

1. Install everything on local using `./install.sh`
2. Create a folder for user stories testing `mkdir -p ai_review/user_stories`
3. Add user stories for your project in the `ai_review/user_stories` folder. For example, [hackernews.yaml](./hackernews.yaml). Create as many user stories as required!
4. Add a new `justfile` to the root of the project. For example, [justfile](../justfile). Update as required.