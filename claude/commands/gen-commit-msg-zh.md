---
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*), Bash(git commit:*), Bash(fork log:*)
description: Generate a git commit
model: haiku
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Your task is to help the user to generate a commit message and commit the changes using git.

### Guidelines

- DO NOT add any ads such as "Generated with [Claude Code](https://claude.ai/code)"
- Only generate the message for staged files/changes
- Don't add any files using `git add`. The user will decide what to add.
- Follow the Format and Rules sections for the commit message.
- Always use the AskUserQuestion tool to confirm the generated commit message before executing `git commit`
- After successfully committing, run `fork log` to open the Fork app for the user to review the commit history in GUI. If sandbox is enabled, use `dangerouslyDisableSandbox: true` for `fork log` only during this command.
- Do not use heredoc for git commit messages. Use multiple `-m` flags instead (first `-m` for title, second `-m` for body).

### Format

```
<type>:<space><message title in Chinese>

<bullet points in Chinese summarizing what was updated>
```

### Example Titles

```
feat(auth): 添加 JWT 登录流程
fix(ui): 修复侧边栏空指针问题
refactor(api): 拆分用户控制器逻辑
docs(readme): 添加使用说明章节
```

### Example with Title and Body

```
feat(auth): 添加 JWT 登录流程

- 实现了 JWT 令牌验证逻辑
- 为验证组件添加了文档说明
```

### Rules

* title is lowercase, no period at the end.
* Title should be a clear summary, max 50 Chinese characters.
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
