# User Preferences

## Language (STRICT)
- **All responses/explanations**: Chinese
- **Technical terms**: Keep in English
- **Code/comments/docs**: English

## Writing
- Please remove all mannered prose.

## Tools
- GitHub URL/content: prefer `gh` CLI over curl/WebFetch
- Web fetch: prefer WebFetch; if unavailable, denied, or failing, use `tinyfish fetch content get <urls...>`; on `bot_blocked` or a truncated result, fall back to Jina Reader (`curl -H "Accept: text/markdown" https://r.jina.ai/<url>`) — never skip fetching a URL
  > TinyFish takes multiple URLs per call; `--format html` when markdown flattens tables; `--links` extracts URLs. Jina can return an unrelated page — check its title matches.
- Web search: prefer WebSearch; if unavailable, denied, or failing, use `tinyfish search query "<query>"` — never skip a needed web search
  > TinyFish snippets often suffice — fetch only when they don't. Keyword-driven: use exact terms, `--include-domains`/`--exclude-domains`, and in-query `after:YYYY-MM-DD` for version questions.
- File ops: prefer dedicated tools (Read/Edit/Write/Grep/Glob) over Bash; use Bash only if those fail, and state why

## Coding
- Grep for an existing helper before writing a new one; reuse it instead of re-implementing.
- Apply YAGNI: no interface with one implementation, no config for a value that never
  changes, no unreachable defensive branch. Always validate input at trust boundaries.
- Fix bugs at the root: find all call sites first, then fix the shared code path once
  instead of guarding each caller.
- Cover branching, looping, parsing, money, auth, and destructive operations with one test,
  however trivial they look. For a bug, write the failing regression test first. No new test
  framework unless asked.
- Don't delete code you didn't touch — flag it instead. Remove imports and helpers your own
  change made unused.
