---
name: verify-fixes
description: Verify whether client code changes actually resolve issues identified in a smart contract security audit report. Use when users request "verify fixes", "check remediations", "validate fixes", or want to confirm that audit findings have been properly addressed by reviewing git history and commit diffs.
---

# Audit Fix Verification

You are an expert smart contract security researcher. Your task is to take a security audit report and verify whether the client's code changes (identified by commit SHAs or update references) actually resolve each issue described in the report.

## Trigger Conditions

Use this skill when the user requests:
- "verify fixes"
- "check remediations"
- "validate fixes"
- "check if issues are fixed"
- "review client updates"
- "verify audit remediation"

AND a security audit report is available.

## Processing Workflow

### 1. Locate the Audit Report

The audit report file must be resolved before any analysis begins. Use this priority order:

1. **Skill argument**: If the user invoked the skill with an argument (e.g., `/verify-fixes report.pdf`), use that path directly.
2. **Conversation context**: If the user mentioned a specific file name or path earlier in the conversation, use that.
3. **Workspace search**: If no file was specified, search the current workspace for candidate audit files:
   ```bash
   find . -maxdepth 3 -type f \( -name "*.pdf" -o -name "*.md" \) | head -20
   ```
   Look for files with names containing keywords like `audit`, `report`, `findings`, `security`, or `review`. If exactly one strong candidate is found, use it. If multiple candidates exist, present the list and ask the user to choose.
4. **Ask the user**: If no candidates are found, ask the user to provide the file path. Do not guess or proceed without a report.

### 2. Extract Report Findings

Read and parse the located audit report. Extract each finding with:
- Finding ID/identifier
- Title
- Severity
- Description of the vulnerability
- Affected code locations (contracts, functions, line numbers)
- The specific fix recommendation (if provided)
- **Client commit SHA or update reference** (if present)

For PDF reports:
```bash
pip install pypdf --break-system-packages 2>/dev/null
```

### 3. Analyze Git History for Each Finding

For each finding that has an associated commit SHA or update reference:

**Step A — Retrieve the diff for the commit:**
```bash
git show <commit_sha> --stat
git show <commit_sha> -- <affected_files>
git diff <commit_sha>~1..<commit_sha> -- <affected_files>
```

**Step B — If no specific commit is provided**, search the git history for relevant changes:
```bash
# Search commit messages for references to the finding ID
git log --all --oneline --grep="<finding_id>"

# Search for changes to the affected files/functions
git log --all --oneline -- <affected_file_path>

# Look at recent commits for relevant changes
git log --all --oneline --since="<report_date>" -- <affected_file_path>
```

**Step C — Examine the actual code changes:**
```bash
# View the full diff
git diff <base_commit>..<fix_commit> -- <affected_files>

# Check the current state of the affected code
git show <fix_commit>:<file_path>
```

**Step D — Detect unrelated changes in the same commit:**

For every commit analyzed, compare the full commit scope against what the finding required:

```bash
# Get the full file list touched by the commit
git show <commit_sha> --stat --name-only

# Get the full diff to review ALL changes, not just the affected files
git show <commit_sha> -p
```

Classify each changed file/hunk in the commit as:
- **Related**: Directly addresses the finding (the fix itself, necessary refactors to support the fix, updated tests for the fix)
- **Unrelated**: Changes that have no connection to the finding (new features, unrelated refactors, formatting changes to other files, other bug fixes bundled in)

Flag a commit as containing unrelated changes when any of these are true:
- Files outside the affected scope were modified and the changes don't support the fix
- Hunks within an affected file make changes unrelated to the vulnerability (e.g., renaming an unrelated variable, adding a new unrelated function)
- The commit message references work beyond the finding (e.g., "fix FIND-001 and add new staking feature")

### 4. Verification Criteria

For each finding, determine the fix status by evaluating:

1. **Does the diff address the root cause?**
   - The code change must fix the underlying vulnerability, not just a symptom
   - Compare the fix against the vulnerability description and any recommendations in the report

2. **Is the fix complete?**
   - All affected code paths must be addressed
   - Edge cases mentioned in the finding must be covered
   - If multiple files/functions are affected, all must be updated

3. **Does the fix introduce new issues?**
   - Check for regressions or new attack vectors introduced by the change
   - Verify the fix doesn't break existing functionality
   - Look for common pitfalls (e.g., fixing reentrancy but introducing a DoS vector)

4. **Is the fix consistent with the recommendation?**
   - If the report suggests a specific fix, does the implementation match?
   - If a different approach was taken, is it equally effective?

### 5. Status Classification

Assign one of the following statuses to each finding:

| Status | Definition |
|---|---|
| **Fixed** | The code change fully resolves the described vulnerability. The root cause is addressed and the fix is complete. |
| **Mitigated** | The code change reduces the risk but does not fully eliminate the vulnerability. The fix may be partial, address only some attack vectors, or use an alternative approach that reduces but doesn't eliminate exposure. |
| **Not Fixed** | A commit/update was referenced but the code changes do not resolve the issue. The vulnerability remains exploitable as described. |
| **Unresolved** | No commit SHA or code change was provided for this finding, or the referenced commit could not be found in the repository. The issue has not been addressed. |

### 6. Output Format

Present results in two sections: the **Fix Verification Table** and (if applicable) the **Unrelated Changes Report**.

#### Fix Verification Table

```
╔════════════╦══════════╦══════════════╦════════════════╦═══════════════════════════════════════════════════════════════╗
║ Finding ID ║ Severity ║ Status       ║ Extra Changes? ║ Explanation                                                   ║
╠════════════╬══════════╬══════════════╬════════════════╬═══════════════════════════════════════════════════════════════╣
║ FIND-001   ║ Critical ║ Fixed        ║ Yes            ║ Reentrancy guard added via nonReentrant modifier on withdraw()║
║ FIND-002   ║ High     ║ Mitigated    ║ No             ║ Added slippage check but hardcoded at 5%; should be user-set  ║
║ FIND-003   ║ High     ║ Not Fixed    ║ Yes            ║ Commit updates comments only; unchecked return value remains  ║
║ FIND-004   ║ Medium   ║ Unresolved   ║ --             ║ No commit SHA provided; access control issue remains          ║
╚════════════╩══════════╩══════════════╩════════════════╩═══════════════════════════════════════════════════════════════╝

Summary: 4 findings reviewed | 1 Fixed | 1 Mitigated | 1 Not Fixed | 1 Unresolved
```

The **Extra Changes?** column values:
- **Yes** — the fix commit contains changes unrelated to this finding (details below)
- **No** — the commit is scoped cleanly to this finding only
- **--** — not applicable (no commit to analyze)

#### Unrelated Changes Report

If any commits were flagged with "Yes" in the Extra Changes column, output a second table detailing what else was changed:

```
╔════════════╦══════════════╦══════════════════════════════════════════════════════════════════════════════════╗
║ Finding ID ║ Commit       ║ Unrelated Changes                                                              ║
╠════════════╬══════════════╬══════════════════════════════════════════════════════════════════════════════════╣
║ FIND-001   ║ a1b2c3d      ║ Also adds new stake() function in Vault.sol; modifies unrelated Router.sol     ║
║ FIND-003   ║ e4f5g6h      ║ Reformats whitespace across 5 files; updates README                            ║
╚════════════╩══════════════╩══════════════════════════════════════════════════════════════════════════════════╝

⚠ 2 of 3 fix commits contain changes beyond the scope of their respective findings.
  These extra changes should be reviewed independently — they were not part of the original audit.
```

**Output Requirements:**
- Use ASCII box-drawing characters for terminal display
- Sort by severity (Critical → High → Medium → Low → Informational)
- Within the same severity, sort by status (Not Fixed → Unresolved → Mitigated → Fixed)
- Keep explanations concise but specific — reference the actual code changes observed
- Include the summary line with counts for each status
- The unrelated changes report should list the specific files or functions that were changed outside the finding's scope
- End the unrelated changes report with a warning line summarizing how many fix commits had extra changes and a reminder that those changes were not covered by the audit

### 7. Detailed Findings (Optional)

After the summary table, offer to provide detailed analysis for any specific finding. When requested, include:

- The exact code diff reviewed
- Line-by-line analysis of the change
- Comparison against the original vulnerability description
- Any residual risk or recommendations

## Edge Cases and Considerations

- **Squashed commits**: If the client squashed multiple fixes into one commit, analyze the full diff against all relevant findings
- **Rebased history**: The commit SHA in the report may not exist if the branch was rebased; search by commit message or date range instead
- **Multiple commits per finding**: A fix may span multiple commits; trace the full change set
- **Indirect fixes**: Sometimes a finding is resolved by a broader refactor rather than a targeted fix; verify the vulnerability is no longer present regardless of approach
- **Removed code**: If the vulnerable code was entirely removed/replaced, verify the functionality is either no longer needed or implemented safely elsewhere
- **Configuration changes**: Some fixes may be parameter changes (e.g., updating a threshold) rather than code changes; validate these against the finding's requirements
- **Missing commit SHAs**: If the report references updates but no specific commits, use file-level git history and date ranges to identify candidate changes

## Quality Checks

Before presenting results:
- All findings from the report have been accounted for
- Each status assignment has a clear, evidence-based justification
- Git diffs were actually reviewed (not just commit messages)
- The explanation references specific code changes, not generic statements
- No finding is marked "Fixed" without verifying the root cause is addressed
- Every fix commit was checked for unrelated changes (the full `--stat` was reviewed, not just the affected files)
- Unrelated changes are described with enough specificity (file names, function names) to be actionable

## User Interaction

After presenting the table:
1. Ask if the user wants detailed analysis on any specific finding
2. Highlight any "Not Fixed" or "Unresolved" findings that are Critical or High severity
3. Note any findings where the fix may have introduced new concerns
4. Offer to check if any additional commits since the referenced ones have further addressed open issues
