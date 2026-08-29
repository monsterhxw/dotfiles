# User Preferences

## Language (STRICT)
- **All responses/explanations**: Chinese
- **Technical terms**: Keep in English
- **Code/comments/docs**: English

## Tools
- GitHub URL/content: prefer `gh` CLI over curl/WebFetch
- Web fetch: prefer WebFetch; if unavailable, denied, or failing, use `tinyfish fetch content get <urls...>`; on `bot_blocked` or a truncated result, fall back to Jina Reader (`curl -H "Accept: text/markdown" https://r.jina.ai/<url>`) — never skip fetching a URL
  > TinyFish takes multiple URLs per call; `--format html` when markdown flattens tables; `--links` extracts URLs. Jina can return an unrelated page — check its title matches.
- Web search: prefer WebSearch; if unavailable, denied, or failing, use `tinyfish search query "<query>"` — never skip a needed web search
  > TinyFish snippets often suffice — fetch only when they don't. Keyword-driven: use exact terms, `--include-domains`/`--exclude-domains`, and in-query `after:YYYY-MM-DD` for version questions.
- File ops: prefer dedicated tools (Read/Edit/Write/Grep/Glob) over Bash; use Bash only if those fail, and state why

## Communication
- Use `AskUserQuestion` tool before acting on assumptions or choosing between approaches
