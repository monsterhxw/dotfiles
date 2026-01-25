---
name: gen-commit-msg
description: Generate and git commit staged changes with a Conventional Commits message. 
disable-model-invocation: true
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*), Bash(git commit:*), Bash(fork log:*), Read
argument-hint: "[zh] - use 'zh' for Chinese commit message"
model: haiku
---

## Context

- Current git status: !`git status`
- Current git diff (staged changes only): !`git diff --staged`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Your task is to help the user to generate a commit message and commit the changes using git.

### Guidelines

- DO NOT add any ads such as "Generated with [Claude Code](https://claude.ai/code)"
- Only generate the message for staged files/changes
- Don't add any files using `git add`. The user will decide what to add.
- Follow the Format and Rules from the template file you read.
- First list the modified files, summarize the changes concisely, and display the generated commit message, then use the **AskUserQuestion tool** to confirm before executing `git commit`
- After successfully committing, run `fork log` to open the Fork app for the user to review the commit history in GUI. If sandbox is enabled, use `dangerouslyDisableSandbox: true` for `fork log` only during this command.
- If sandbox is enabled, do not use heredoc for git commit messages. Use multiple `-m` flags instead (first `-m` for title, second `-m` for body).

### Format

| Language | Trigger | Template |
|----------|---------|----------|
| English | Default | [format-en.md](format/format-en.md) |
| Chinese | `$ARGUMENTS` = `zh` or user mentions "中文/Chinese" | [format-zh.md](format/format-zh.md) |

### Rules

* title is lowercase, no period at the end.
* Title should be a clear summary, max 50 characters (or 50 Chinese characters).
* Use the body (optional) to explain *why*, not just *what*.
* Bullet points should be concise and high-level.

Avoid

* Vague titles like: "update", "fix stuff"
* Overly long or unfocused titles
* Excessive detail in bullet points

### Allowed Types

| Type     | Description                           |
| -------- | ------------------------------------- |
| feat     | New feature                           |
| fix      | Bug fix                               |
| chore    | Maintenance (e.g., tooling, deps)     |
| docs     | Documentation changes                 |
| refactor | Code restructure (no behavior change) |
| test     | Adding or refactoring tests           |
| style    | Code formatting (no logic change)     |
| perf     | Performance improvements              |
