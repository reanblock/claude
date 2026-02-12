---
name: audit-vuln-review
description: Review a potential security vulnerability in a codebase. Takes a list of files where the vulnerability may exist and a description of the suspected issue. Assesses validity, severity, fix approach, and checks for the same vulnerability elsewhere in the repo. Use when users request "vulnerability review", "review this finding", "check this vulnerability", "audit vuln review", "is this a valid finding", or provide files and a vulnerability description for assessment. Supports Solidity, Vyper, Rust (Solana/CosmWasm), Move, and other smart contract languages.
---

# Security Vulnerability Review

This skill reviews a potential security vulnerability in a codebase. Given a set of files and a vulnerability description, it assesses validity, explains the issue, recommends a fix, checks for the same pattern elsewhere in the repo, and assigns an appropriate severity.

## Trigger Conditions

Use this skill when the user:
- Requests "vulnerability review", "review this finding", "check this vulnerability", "potential security vulnerability"
- Provides a list of files AND a vulnerability description
- Asks "is this a valid finding?"
- Asks to assess a suspected security issue

AND provides:
1. One or more file paths where the vulnerability is suspected
2. A description of the vulnerability

## Input Requirements

- **Affected files**: One or more file paths where the vulnerability is suspected to exist.
- **Vulnerability description**: A text description explaining the suspected vulnerability in those files.

Example invocation:

```
I need to review a potential security vulnerability in this project that is possibly located in the following files:

file1.sol
file2.sol

The vulnerability is described as follows:

Lack of access control on the `withdraw()` function allows any caller to drain funds from the vault.
```

## Processing Workflow

**IMPORTANT**: DO NOT MAKE CHANGES TO THE CODE OR MAKE ANY COMMITS USING GIT.

### 1. Parse and Validate Input

- Extract the list of affected file paths from the user's message
- Extract the vulnerability description
- Verify each file exists; report any missing files immediately
- If either the file list or the vulnerability description is missing, stop and ask the user to provide the missing information

### 2. Understand the Vulnerability

Before reading any code, analyze the vulnerability description to understand:
- **What category of vulnerability is this?** (access control, reentrancy, integer overflow, logic error, oracle manipulation, front-running, etc.)
- **What is the claimed impact?** (fund loss, DoS, privilege escalation, information leak, etc.)
- **What is the attack vector?** (who can exploit it, what preconditions are needed)

### 3. Read and Analyze the Affected Files

Read each file listed by the user. For each file:

1. **Locate the relevant code**: Find the specific functions, modifiers, state variables, or logic paths that relate to the described vulnerability
2. **Trace the execution flow**: Follow the code path an attacker would take to exploit the vulnerability — trace calls, state changes, modifiers, and external interactions
3. **Check for existing mitigations**: Look for guards that may already prevent the issue:
   - Access control modifiers (`onlyOwner`, `onlyRole`, `require(msg.sender == ...)`)
   - Reentrancy guards (`nonReentrant`, mutex patterns)
   - Input validation (`require`, `assert`, boundary checks)
   - Safe math usage (Solidity >=0.8 built-in overflow checks, SafeMath, etc.)
   - Pause mechanisms, timelocks, or other safety rails
4. **Evaluate exploitability**: Determine if the vulnerability can actually be triggered given the full context of the code (not just the isolated snippet)

### 4. Assess Validity

Classify the finding as one of:

| Verdict | Definition |
|---------|-----------|
| **VALID** | The vulnerability exists and is exploitable as described (or with minor variation). The code lacks sufficient mitigation. |
| **FP** | False positive. The vulnerability does not exist because: the code already has mitigations, the preconditions cannot be met, the execution path is unreachable, or the description misunderstands the code logic. |

When assessing validity, consider:
- Is the affected code actually reachable?
- Are there modifiers or checks earlier in the call chain that prevent exploitation?
- Does the compiler version or language feature already mitigate this? (e.g., Solidity >=0.8 overflow protection)
- Are the preconditions for exploitation realistic?
- Does the broader protocol context make exploitation impractical?

### 5. Determine Severity

If the finding is **VALID**, assign a severity:

| Severity | Criteria |
|----------|----------|
| **HIGH** | Direct loss of funds, unauthorized fund transfers, protocol insolvency, bypassing critical access control, exploitable in a single transaction or with minimal setup. High likelihood of exploitation with significant financial impact. |
| **MED** | Conditional fund loss (requires specific state or unlikely preconditions), partial protocol disruption, governance manipulation, economic exploits with limited profitability, or issues that degrade protocol security but require complex attack chains. |
| **LOW** | Minimal financial impact, best practice violations with theoretical risk, edge cases with negligible impact, issues requiring extreme or impractical preconditions, gas inefficiencies, or minor logic inconsistencies that don't affect core functionality. |
| **INFORMATIONAL** | No direct security impact. Code quality suggestions, documentation gaps, style improvements, minor gas optimizations, or deviations from best practices that don't introduce risk. |

If the finding is **FP**, severity is not applicable — but still note what severity it *would* have been if it were valid, to help contextualize why the false positive was worth investigating.

### 6. Search for the Same Vulnerability Elsewhere

Scan the **entire repository** (not just the listed files) for the same vulnerability pattern:

1. **Identify the vulnerable pattern**: Distill the vulnerability into a searchable code pattern (e.g., an unprotected external call, a missing access control check on a specific type of function, an unchecked return value)
2. **Search broadly**: Use grep/ripgrep to find similar patterns across all files in the repo
3. **Analyze each match**: For each occurrence found, determine if the same vulnerability applies or if it is mitigated in that context
4. **Report findings**: List any additional locations where the same vulnerability is present, with file paths and line numbers

### 7. Recommend a Fix

Provide a clear, actionable fix recommendation:

- Explain **what** needs to change and **why**
- Provide a concise code example showing the fix (before → after, or just the corrected version)
- If multiple fix approaches exist, list them with trade-offs
- Note if the fix could introduce new issues (e.g., adding a reentrancy guard might cause issues with legitimate callbacks)
- Keep the fix minimal — address the vulnerability without unnecessary refactoring

## Output Format

Present the review directly in the conversation using this structure:

```
## Vulnerability Review

**Files Reviewed**: <list of files>
**Vulnerability**: <one-line summary of the claimed vulnerability>

---

### Explanation

<Brief, clear explanation of the vulnerability in 2-4 sentences. What is the issue, why does it matter, and how could it be exploited?>

**Simple Example:**

<A minimal, self-contained code snippet (5-15 lines) demonstrating the vulnerability pattern in isolation. This should be understandable without needing to read the actual codebase. Use the same language as the project.>

---

### Validity Assessment: [VALID | FP]

<2-4 sentences explaining the reasoning. Reference specific code: file paths, function names, line numbers, modifiers, or checks that support the conclusion.>

<If FP: explain exactly what mitigates the issue — cite the specific guard, check, or design choice.>

---

### Severity: [HIGH | MED | LOW | INFORMATIONAL]

<1-2 sentences justifying the severity based on impact, likelihood, and exploitability.>

<If FP: "N/A (False Positive) — would be [SEVERITY] if valid.">

---

### Recommended Fix

<Explanation of the fix approach in 1-3 sentences.>

**Before:**
<code snippet showing the vulnerable code>

**After:**
<code snippet showing the fixed code>

<If multiple approaches exist, list alternatives briefly.>

---

### Other Occurrences

<If the same pattern was found elsewhere in the repo:>

| File | Line(s) | Status | Notes |
|------|---------|--------|-------|
| path/to/file.sol | L42-48 | Vulnerable | Same missing access control on similar function |
| path/to/other.sol | L115 | Mitigated | Has `onlyOwner` modifier — not affected |

<If no other occurrences: "No other instances of this vulnerability pattern were found in the repository.">
```

## Edge Cases and Considerations

- **Incomplete vulnerability description**: If the description is vague, do your best to interpret it but note assumptions. Ask for clarification if the description is too ambiguous to make any assessment.
- **Files reference external dependencies**: If the vulnerability involves interactions with imported libraries or interfaces, read those files too (node_modules, lib/, etc.) to understand the full picture.
- **Vulnerability spans multiple files**: Some vulnerabilities only emerge from the interaction between contracts (e.g., cross-contract reentrancy). Trace the full call chain across files.
- **Upgradeable contracts**: If the contract is behind a proxy, check both the implementation and proxy for the vulnerability. Storage layout issues may also be relevant.
- **Multiple vulnerabilities in one request**: If the user describes more than one distinct vulnerability, assess each one separately with its own section.
- **Already-known vulnerability**: If the finding matches a well-known vulnerability pattern (e.g., ERC-20 approval race condition, Solidity delegatecall to untrusted contract), reference the known pattern by name.

## Quality Checks

Before presenting the review:
- The affected files were actually read and analyzed (not assessed from description alone)
- The validity assessment cites specific code evidence (file, function, line)
- The simple example is accurate and demonstrates the actual vulnerability pattern
- The severity aligns with the criteria defined above
- The fix recommendation is correct and does not introduce new vulnerabilities
- The repo-wide search was actually performed (grep/search was run, not assumed)
- The "Other Occurrences" section reflects real search results

## User Interaction

After presenting the review:
1. Ask if the user wants to drill deeper into any section (e.g., trace the full call chain, examine a specific occurrence)
2. If the finding is VALID, offer to check if the recommended fix would address all occurrences
3. If additional context changes the assessment, be willing to revise the verdict
4. If the user has multiple vulnerabilities to review, offer to process them one at a time or in batch
