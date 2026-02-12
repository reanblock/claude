---
name: audit-scope
description: Perform a client audit scoping assessment on a codebase. Analyzes in-scope files for lines of code, test quality, documentation quality, complexity, and external integrations. Produces a scoping report with estimated audit hours and BD feedback. Use when users request "audit scope", "scope audit", "scoping assessment", "audit estimate", "client audit scope", or provide a list of in-scope files for audit estimation. Supports Solidity, Vyper, Rust (Solana/CosmWasm), Move, and other smart contract languages.
---

# Client Audit Scoping Assessment

This skill takes a list of in-scope files and performs a comprehensive scoping assessment of a codebase to estimate audit effort, evaluate readiness, and provide actionable feedback for the BD lead and client.

## Trigger Conditions

Use this skill when the user requests:
- "audit scope"
- "scope audit"
- "scoping assessment"
- "audit estimate"
- "client audit scope"
- "scope these files"

AND provides a comma-separated list of in-scope files (or a path pattern).

## Input Requirements

- **In-scope files**: A comma-separated list of file paths that are in scope for the audit.
  - Example: `src/Vault.sol, src/Router.sol, src/libraries/MathLib.sol`
  - Can also be glob patterns: `src/contracts/*.sol`
- The files must exist in the current working directory or a specified project path.

## Processing Workflow

### 1. Validate In-Scope Files

Parse the comma-separated input and resolve each file path:

- Verify every file exists; report any missing files immediately
- Normalize paths (trim whitespace, resolve relative paths)
- Group files by language/type (Solidity, Vyper, Rust, Move, Cairo, etc.)
- If no files are provided or the argument is empty, stop and ask the user for the file list

### 2. Measure Lines of Code

Use `scc` (preferred) or `cloc` to count lines of code for **only the in-scope files**.

```bash
# Preferred: scc (fast, accurate)
scc --no-cocomo --no-complexity <file1> <file2> ...

# Fallback: cloc
cloc <file1> <file2> ...
```

If neither tool is installed, attempt to install:
```bash
# Try scc first
brew install scc 2>/dev/null || go install github.com/boyter/scc/v3@latest 2>/dev/null

# Fallback to cloc
brew install cloc 2>/dev/null || pip install cloc 2>/dev/null || apt-get install -y cloc 2>/dev/null
```

Record:
- **Total LoC** (code lines only, excluding blanks and comments)
- **Per-file breakdown** (file name, language, code lines)
- **Total comment lines** (used for documentation quality assessment)

### 3. Assess Documentation Quality

Evaluate documentation across multiple dimensions:

**In-repo documentation:**
- Check for README, docs/, or wiki/ directories in the project
- Look for architecture diagrams, protocol descriptions, or specification documents
- Examine NatSpec/rustdoc/docstring coverage in the in-scope files:
  - Count functions with documentation vs. total functions
  - Check for `@notice`, `@dev`, `@param`, `@return` (Solidity) or equivalent annotations
  - Note any functions with complex logic that lack explanatory comments

**External documentation:**
- Search online for the project's documentation site, whitepaper, or technical docs
- Check for links in the README to external docs

**Assign a rating:**
- **High**: Comprehensive NatSpec/docstrings on most functions, architecture docs exist, README explains the protocol clearly, external docs or whitepaper available
- **Med**: Partial documentation — some functions documented but gaps exist, README present but light on detail, no architecture docs
- **Low**: Minimal or no inline documentation, no README or unhelpful README, no external docs found

### 4. Run Project Tests

Detect the testing framework and attempt to run the full test suite.

**Detection order:**
```bash
# Foundry (Solidity)
ls foundry.toml 2>/dev/null && forge test

# Hardhat (Solidity)
ls hardhat.config.* 2>/dev/null && npx hardhat test

# Anchor (Solana/Rust)
ls Anchor.toml 2>/dev/null && anchor test

# Cargo (Rust)
ls Cargo.toml 2>/dev/null && cargo test

# Ape (Vyper/Solidity)
ls ape-config.yaml 2>/dev/null && ape test

# Brownie (Solidity/Vyper)
ls brownie-config.yaml 2>/dev/null && brownie test

# Move
ls Move.toml 2>/dev/null && aptos move test
```

If dependencies are not installed, attempt to install them first:
```bash
# Foundry
forge install 2>/dev/null

# Hardhat
npm install 2>/dev/null || yarn install 2>/dev/null

# Rust
cargo build 2>/dev/null
```

**Record:**
- Total tests run
- Tests passed / failed / skipped
- Any compilation errors preventing test execution
- Test coverage percentage (if available via `forge coverage`, `npx hardhat coverage`, etc.)
- Time taken to run the test suite

**Assign a rating:**
- **High**: All tests pass, good coverage (>80%), tests cover edge cases and integrations
- **Med**: Most tests pass (>90% pass rate), moderate coverage (40-80%), some gaps in edge case testing
- **Low**: Tests failing, low coverage (<40%), tests only cover happy paths, or no tests at all

### 5. Analyze Code Complexity

Review the in-scope files to assess complexity factors that affect audit effort:

**Complexity indicators (each adds a multiplier):**
- **Inline assembly / Yul** (`assembly { ... }`) — +0.3x multiplier
- **Complex mathematical operations** (fixed-point math, custom curve implementations, bonding curves, AMM formulas) — +0.2x to +0.5x multiplier
- **Proxy/upgradeable patterns** (delegatecall, UUPS, Transparent Proxy, Diamond/EIP-2535) — +0.2x multiplier
- **Cross-contract calls / external integrations** (calls to external protocols like Uniswap, Aave, Chainlink, etc.) — +0.2x per major integration
- **Novel or unconventional patterns** (non-standard token implementations, custom EVM tricks, unusual inheritance hierarchies) — +0.2x multiplier
- **Cross-chain messaging** (bridges, LayerZero, Axelar, Wormhole) — +0.3x multiplier
- **Multiple languages** (e.g., Solidity + Rust components) — +0.2x multiplier

Calculate the **complexity multiplier** as: `1.0 + sum(applicable multipliers)`, capped at 3.0x.

### 6. Identify External Integrations

Scan the in-scope files for interactions with external protocols, oracles, or infrastructure:

- **DEX integrations** (Uniswap, Curve, Balancer, etc.)
- **Lending protocols** (Aave, Compound, Morpho, etc.)
- **Oracle usage** (Chainlink, Pyth, UMA, TWAP, etc.)
- **Vault/pool interactions** (ERC-4626, Yearn, Convex, etc.)
- **Bridge/cross-chain** (LayerZero, Axelar, Wormhole, CCIP, etc.)
- **Governance** (OpenZeppelin Governor, custom governance, timelocks)
- **Token standards** (ERC-20, ERC-721, ERC-1155, ERC-4626, custom)

List each integration with the specific files/functions involved. This is critical for BD — it tells us which areas need focused attention during the audit.

### 7. Identify Positive Aspects

Note things the client is doing well:

- Well-structured code with clear separation of concerns
- Comprehensive test suite with good coverage
- Use of battle-tested libraries (OpenZeppelin, Solmate, etc.)
- Good NatSpec documentation and inline comments
- Following established security patterns (checks-effects-interactions, reentrancy guards, access control)
- Clean git history with meaningful commits
- Use of formal verification or static analysis tools (Slither, Mythril, Certora, etc.)
- Existing audit reports from other firms

### 8. Calculate Audit Estimates

Use the following formulas:

```
Total LoC         = sum of code lines across all in-scope files
Complexity Mult   = calculated from Step 5 (minimum 1.0, max 3.0)

Audit Hours       = (Total LoC / 100) * Complexity Mult
Ramp Up           = Audit Hours * 0.05 to 0.10  (5-10%, higher for complex/novel protocols)
Report            = Audit Hours * 0.10 to 0.15  (10-15%, higher for larger audits)
Communication     = 1 to 3 hours                (higher for complex protocols with many integrations)
Fix Review        = Audit Hours * 0.05 to 0.10  (5-10% of audit time)
```

Round all hours to the nearest whole number. Use professional judgment to pick within the ranges based on the complexity and size of the codebase.

### 9. Generate BD Feedback

Compile actionable feedback for the BD lead covering:

**Mini-Summary:**
- What the protocol does (1-2 sentences)
- Noteworthy aspects: architecture, integrations, novel patterns
- Overall impression of audit readiness

**Recommendations for the Client:**
- If tests are failing or sparse: explain what's wrong and suggest how to prepare better tests before the audit begins
- If documentation is lacking: point out gaps and recommend adding NatSpec, architecture docs, or a protocol specification
- If code is overly complex: suggest simplification opportunities
- If external integrations lack interface documentation: recommend providing integration specs
- General advice to make the audit process smoother (e.g., "freeze the codebase before audit start", "provide deployment scripts", "document admin/privileged roles")

**Positive Feedback:**
- Highlight what the client is doing well (shows we understand their work and builds trust)
- Acknowledge good practices, clean code, thoughtful architecture, etc.

**Areas Requiring Focused Attention:**
- External protocol integrations (vaults, pools, oracles) — these are common sources of bugs
- Any assembly or complex math sections
- Privileged roles and access control patterns
- Upgrade mechanisms

## Output Format

Save the complete scoping report as a markdown file named `audit-scope-report.md` in the current working directory.

### Report Structure

```markdown
# Audit Scoping Report

**Project**: <project name from README, package.json, or directory name>
**Date**: <current date>
**Files in Scope**: <count of in-scope files>
**Total LoC**: <total lines of code>

---

## Scoping Summary

| Category       | Estimate                              |
|----------------|---------------------------------------|
| Docs Quality   | [High\|Med\|Low]                      |
| Test Quality   | [High\|Med\|Low]                      |
| Ramp Up        | N h / auditor                         |
| Audit          | N LoC / 100 = N h / auditor           |
| Report         | N h                                   |
| Communication  | N h / auditor                         |
| Fix Review     | N h / auditor                         |

**Complexity Multiplier**: X.Xx (justification: <brief reason>)
**Adjusted Audit Estimate**: N h / auditor (after complexity multiplier)

---

## Lines of Code Breakdown

<scc or cloc output for in-scope files>

| File | Language | Code Lines |
|------|----------|------------|
| ... | ... | ... |
| **Total** | | **N** |

---

## Test Results

**Framework**: <detected framework>
**Result**: N passed, N failed, N skipped
**Coverage**: N% (if available)

<brief commentary on test quality>

---

## External Integrations

<list each integration with files/functions involved>

---

## Complexity Analysis

<list complexity factors found with their multipliers>

---

## Positive Aspects

<bulleted list of things the client is doing well>

---

## Recommendations

<bulleted list of actionable suggestions for the client>

---

## BD Feedback Summary

<mini-summary for the BD lead: what the protocol does, noteworthy aspects, overall readiness, and key areas to highlight during audit>
```

## Edge Cases and Considerations

- **Monorepo projects**: The in-scope files may be spread across multiple packages/directories. Handle path resolution accordingly.
- **Missing test frameworks**: If no test framework is detected, note it as a concern and rate Test Quality as Low.
- **Compilation failures**: If the project doesn't compile, note the errors. This affects test quality rating and should be flagged as a recommendation.
- **Very large scope (>5000 LoC)**: For large scopes, the report time and communication time should trend toward the higher end of their ranges.
- **Very small scope (<500 LoC)**: For small scopes, ensure minimum viable estimates (e.g., at least 1h for ramp-up, 1h for communication).
- **Mixed language projects**: Count LoC per language and note the multi-language complexity multiplier.
- **Files outside the provided list**: Do not include files that were not specified in the input, even if they appear relevant. The scope is defined by the client.
- **No internet access**: If external documentation cannot be searched, base the Docs Quality rating solely on in-repo documentation.

## Quality Checks

Before saving the report:
- All in-scope files have been accounted for in the LoC count
- The LoC tool (scc/cloc) was actually run (not estimated)
- Tests were actually executed (not assumed from file existence)
- The complexity multiplier is justified with specific evidence from the code
- Hour estimates follow the defined formulas and are internally consistent
- The scoping summary table is complete with all rows filled
- BD feedback is constructive, professional, and actionable
- Positive aspects are genuine and specific (not generic praise)
- The report file has been saved to `audit-scope-report.md`

## User Interaction

After generating the report:
1. Confirm the report has been saved and provide the file path
2. Display the Scoping Summary table directly in the conversation for quick reference
3. Highlight any critical findings (e.g., "Tests are failing — recommend client fixes these before audit")
4. Offer to drill into any specific section (complexity analysis, integration details, etc.)
5. Ask if the scope or any estimates need adjustment based on additional context the user may have
