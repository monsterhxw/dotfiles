# User Preferences

## Language (STRICT)
- **All responses/explanations**: Chinese
- **Technical terms**: Keep in English
- **Code/comments/docs**: English

## Tools
- Web search: if WebSearch is unavailable or fails, use `anysearch` skill instead
- GitHub URL/content: prefer `gh` CLI over curl/WebFetch
- `curl`: When fetching web content, prefer Jina Reader API (`curl -H "Accept: text/markdown" https://r.jina.ai/<url>`) for clean Markdown output

## Communication
- Use `AskUserQuestion` tool before acting on assumptions or choosing between approaches
