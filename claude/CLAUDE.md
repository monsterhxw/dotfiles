# User Preferences

## Language (STRICT)
- **All responses/explanations**: Chinese
- **Technical terms**: Keep in English
- **Code/comments/docs**: English

## Tools
- GitHub URL/content: prefer `gh` CLI over curl/WebFetch
- Web fetch: if WebFetch is unavailable or fails, use Jina Reader API via curl (`curl -H "Accept: text/markdown" https://r.jina.ai/<url>`) for clean Markdown output
- Web search: if WebSearch is unavailable or fails, use `anysearch` skill instead
- File edits: prefer **Edit** or **Write** tools; use shell only if those tools fail, and state the reason

## Communication
- Use `AskUserQuestion` tool before acting on assumptions or choosing between approaches
