---
description: Explore and document a new project codebase.
argument-hint: "[depth: shallow|standard|deep]"
allowed-tools: Bash, ReadFile, WriteFile, ListDirectory
---

Perform a comprehensive analysis of the current codebase and provide a structured overview. Investigate the following areas:

## Instructions

1. **Project Overview** - Read the README, package.json (or equivalent manifest), and top-level config files to determine what this project is about and what language/framework it uses.

2. **Dependencies** - List the key production and dev dependencies. Highlight the major frameworks, libraries, and tools being used.

3. **Project Structure** - Explore the directory layout and describe how the code is organized (e.g., src/, lib/, components/, etc.). Note any architectural patterns (MVC, feature-based, etc.).

4. **Testing** - Determine if tests exist by looking for test directories, test files (*.test.*, *.spec.*, etc.), and test configuration (jest.config, vitest.config, .mocharc, pytest.ini, etc.). Identify the testing framework and report on test coverage if available.

5. **Build & Dev Tools** - Identify the build system, bundler, linter, formatter, CI/CD config, and any other developer tooling.

6. **Scripts / Commands** - List available npm scripts (or equivalent task runner commands) and what they do.

7. **Notable Patterns** - Call out any interesting architectural decisions, patterns, or conventions used in the codebase.

## Output Format

Present the findings in a clean, readable summary with sections for each area above. Be concise but thorough. If something is missing (e.g., no tests), explicitly state that.
