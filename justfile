default_prompt := "Get the current date, then go to https://simonwillison.net/, find the latest blog post by Simon, summarize it, and give it a rating out of 10."

default_qa_prompt := "Navigate to https://news.ycombinator.com/. Verify the front page loads with posts. Click 'More' to go to the next page. Verify page 2 loads with a new set of posts. Go back to page 1. Click into the first post's comments link. Verify the comments page loads and at least one comment is visible."

# List available commands
default:
    @just --list

# Playwright skill — direct (headless by default) - use as a sanity that everything is wired up correctly and to test basic functionality of the skill. 
test-playwright-skill headed="true" prompt=default_prompt:
    claude --dangerously-skip-permissions --model opus "/playwright-bowser (headed: {{headed}}) {{prompt}}"

# QA agent — structured user story validation
test-qa headed="true" prompt=default_qa_prompt:
    claude --dangerously-skip-permissions --model opus "Use a @bowser-qa-agent: (headed: {{headed}}) {{prompt}}"

# UI Review — parallel user story validation across all YAML stories
ui-review headed="headed" filter="" *flags="":
    claude --dangerously-skip-permissions --model opus "/bowser:ui-review {{headed}} {{filter}} {{flags}}"