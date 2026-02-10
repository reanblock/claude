## Hook Summary Table

┌──────────────────────────────────────┬────────────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                 Hook                 │       Event        │                                             Summary                                              │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ pre_tool_use.py                      │ PreToolUse         │ Blocks rm -rf commands and .env file access; logs all tool calls                                 │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ post_tool_use.py                     │ PostToolUse        │ Logs all successful tool call results                                                            │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ post_tool_use_failure.py             │ PostToolUseFailure │ Logs failed tool calls with structured error details                                             │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ permission_request.py                │ PermissionRequest  │ Auto-allows read-only ops (Read/Glob/Grep/safe Bash); logs permission requests                   │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ user_prompt_submit.py                │ UserPromptSubmit   │ Logs user prompts; manages session data; optional agent naming via LLM                           │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ session_start.py                     │ SessionStart       │ Logs session start; optionally loads dev context (git, TODOs, issues) and announces via TTS      │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ session_end.py                       │ SessionEnd         │ Logs session end; optional cleanup of temp files and stale chat.json                             │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ setup.py                             │ Setup              │ Logs setup; checks tool versions; gathers project info; optional dependency install              │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ stop.py                              │ Stop               │ Logs stop events; optional chat transcript export; optional LLM-generated TTS completion message │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ notification.py                      │ Notification       │ Logs notifications; optional TTS "your agent needs input" with random name personalization       │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ subagent_start.py                    │ SubagentStart      │ Logs subagent spawns; optional TTS announcement                                                  │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ subagent_stop.py                     │ SubagentStop       │ Logs subagent stops; optional TTS with LLM-summarized task description and TTS queue locking     │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ pre_compact.py                       │ PreCompact         │ Logs compaction events; optional transcript backup before compaction                             │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ validators/ruff_validator.py         │ PostToolUse        │ Runs ruff check on Python files after Write; blocks on lint errors                               │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ validators/ty_validator.py           │ PostToolUse        │ Runs ty check on Python files after Write; blocks on type errors                                 │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ validators/validate_new_file.py      │ Stop               │ Validates a new file was created in a specified directory                                        │
├──────────────────────────────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ validators/validate_file_contains.py │ Stop               │ Validates a new file contains required content strings                                           │
└──────────────────────────────────────┴────────────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────┘