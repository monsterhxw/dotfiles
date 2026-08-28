# User Preferences

## Language (STRICT)
- **All responses/explanations**: Chinese
- **Technical terms**: Keep in English
- **Code/comments/docs**: English

## Tools
- GitHub URL/content: prefer `gh` CLI over curl/WebFetch
- Web fetch: prefer WebFetch; if unavailable, denied, or failing, use `tinyfish fetch content get <urls...>`; on `bot_blocked`, fall back to Jina Reader (`curl -H "Accept: text/markdown" https://r.jina.ai/<url>`) — never skip fetching a URL
  > Batch URLs in one call; they fetch in parallel. `--format html` preserves tables (markdown flattens them); `--links` extracts URLs. Jina sometimes returns an unrelated page — confirm its title matches the URL.
- Web search: prefer WebSearch; if unavailable, denied, or failing, use `tinyfish search query "<query>"` — never skip a needed web search
  > Snippets often answer the question — fetch only when they don't. Keyword-driven, not semantic: use exact terms, `--include-domains`/`--exclude-domains`, and in-query `site:` / `after:YYYY-MM-DD`. Add `after:` for version questions.
- File edits: prefer **Edit** or **Write** tools; use shell only if those tools fail, and state the reason

## Communication
- Use `AskUserQuestion` tool before acting on assumptions or choosing between approaches
