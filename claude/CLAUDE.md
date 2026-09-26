# User Preferences

## Language
- **All responses/explanations**: Chinese
- **Technical terms**: Keep in English
- **Code/comments/docs**: English

## Writing
- Please remove all mannered prose.

## Tools
- GitHub URL/content: prefer `gh` CLI over curl/WebFetch
- Web fetch: prefer WebFetch; if unavailable, denied, or failing, use `tinyfish fetch content get <urls...>`; on `bot_blocked` or a truncated result, fall back to Jina Reader (`curl -H "Accept: text/markdown" https://r.jina.ai/<url>`) — never skip fetching a needed URL
  > TinyFish takes multiple URLs per call; `--format html` when markdown flattens tables; `--links` extracts URLs. Jina can return an unrelated page — check its title matches.
- Web search: prefer WebSearch; if unavailable, denied, or failing, use `tinyfish search query "<query>"` — never skip a needed web search
  > TinyFish snippets often suffice — fetch only when they don't. Keyword-driven: use exact terms, `--include-domains`/`--exclude-domains`, and in-query `after:YYYY-MM-DD` for version questions.
- File ops: use Read to read, Edit to change existing files, Write to create new ones. Never view or write file contents through Bash (cat, head, tail, sed, `>`/`>>`, heredoc, tee). Use Bash only for what no other loaded tool covers (delete, move, copy, chmod); state why when it modifies files. If a loaded tool fails, fix the cause (e.g. Read first) instead of falling back to Bash. Confirm before deleting anything not created in this session. Once the whole task is done, not each turn, delete temp/backup files you created.

## Coding
- Grep for an existing helper before writing a new one; reuse it instead of re-implementing.
- Apply YAGNI: no interface with one implementation, no config for a value that never changes, no unreachable defensive branch. Always validate input at trust boundaries.
- Fix bugs at the root: find all call sites first, then fix the shared code path once instead of guarding each caller.
- Cover branching, looping, parsing, money, auth, and destructive operations with one test, however trivial they look. For a bug, write the failing regression test first. No new test framework unless asked.
- Don't delete code you didn't touch — flag it instead. Remove imports and helpers your own change made unused.
- Comments explain only WHY: intent, a non-obvious constraint, or a workaround (link the issue if one exists; otherwise note when it can be removed). Never restate WHAT or narrate the change — both go stale; history belongs in the commit message. Lock behavior with a test, not a comment.
- When changing code, update or delete the comments it makes stale; carry existing WHY comments through refactors.
