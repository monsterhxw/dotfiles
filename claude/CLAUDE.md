# User Preferences

## Language (STRICT)
- **All responses/explanations**: Chinese
- **Technical terms**: Keep in English
- **Code/comments/docs**: English

## Tools
- GitHub URL/content: prefer `gh` CLI over curl/WebFetch
- Web fetch: prefer WebFetch when available; if it is absent or fails, immediately use Jina Reader API via curl (`curl -H "Accept: text/markdown" https://r.jina.ai/<url>`) instead — never skip fetching a URL for lack of WebFetch
- Web search: prefer WebSearch when available; if the WebSearch tool is absent from available tools or a call is denied/fails, immediately fall back to the `exa-search` skill — never skip or refuse a needed web search for lack of WebSearch
- File edits: prefer **Edit** or **Write** tools; use shell only if those tools fail, and state the reason

## Communication
- Use `AskUserQuestion` tool before acting on assumptions or choosing between approaches
