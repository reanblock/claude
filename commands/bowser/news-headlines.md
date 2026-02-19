---
description: Visit a news site, find today's top headline, summarize it, and list people involved
argument-hint: <news-url>
---

# News Headline Summarizer

Visit a news site, find today's top headline, summarize the article, and identify people involved.

## Variables

| Variable | Value               | Description                            |
| -------- | ------------------- | -------------------------------------- |
| SKILL    | `playwright-bowser` | Headless browser (no auth needed)      |
| MODE     | `headless`          | No visible browser                     |

## Workflow

1. Navigate to: {PROMPT}
2. Verify the news site loads (look for headline listings or featured stories)
3. Identify today's top headline story
4. Click into the headline article
5. Verify the full article content loads
6. Read the headline, date, and article body
7. Report the following:
   - **Headline**: The exact headline text
   - **Summary**: A concise 3-5 bullet point summary of the article
   - **People Involved**: A list of all people mentioned in the article, with a brief note on their role or relevance to the story
