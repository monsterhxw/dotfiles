---
name: drawio-diagram
description: Use when the user requests any visual diagram using draw.io - flowcharts, architecture diagrams, UML, ERD, sequence diagrams, org charts, mind maps, wireframes, network topology, or other diagramming needs
argument-hint: "[language: zh-CN (default) | en | ja | ...]"
allowed-tools:
  - Write
  - Read
  - Bash(python3:*)
  - Bash(python:*)
metadata:
  author: jgraph
  source: https://github.com/jgraph/drawio-mcp
---

# Draw.io Diagram Generation

Generate draw.io diagrams by creating compressed URLs via Python and opening them in the browser.

## Configuration

### Working Directory
Current working directory: !`pwd`

### Language
- **Default**: `zh-CN` (Chinese)
- **Resolution order** (highest priority first):
  1. `$0` argument from `/drawio-diagram [language]` invocation
  2. Language preference explicitly mentioned in the user's request (e.g., "用英文画", "draw in Japanese")
  3. Default: `zh-CN`
- Diagram labels, notes, and descriptions should use the resolved language
- Technical terms (protocol names, opcodes, HTTP headers, status codes, framework names, etc.) MUST remain in English
- Examples:
  - `zh-CN`: "握手阶段" (not "Handshake Phase"), but keep "HTTP GET", "101 Switching Protocols"
  - `en`: "Handshake Phase", "HTTP GET", "101 Switching Protocols" (all English)

## Reference

Read [claude-project-instructions.md](references/claude-project-instructions.md) (relative to this skill file) for the complete diagram generation instructions, including:
- Supported diagram types
- Format selection guide (Mermaid / CSV / XML)
- Python URL generation code
- Format examples (Mermaid, XML, CSV syntax)

## Agent CLI Adaptation

The reference instructions mention "HTML artifact" — in Agent CLI environments there are no artifacts. Instead:

1. **Modify the Python script**: At the end of the script (after generating the URL), add `import webbrowser; webbrowser.open(url)` to directly open the draw.io URL in the default browser — no intermediate HTML page needed
2. **Save HTML backup**: Save the HTML to `{intent}-{type}-{timestamp}.html` in the current working directory (see Configuration > Working Directory above). Naming convention:
   - `{intent}`: 1-5 word kebab-case subject (e.g., `mqtt-conn`, `user-auth-flow`)
   - `{type}`: Abbreviated diagram type (e.g., `seq`, `flow`, `erd`, `arch`, `class`, `mind`)
   - `{timestamp}`: Format `YYYYMMDDHHMMSS`
   - Example: `mqtt-conn-seq-20260211143052.html`
   - **Retry / fix of a previous diagram** (e.g., user reports an error, asks for style tweaks, or requests content changes to the same diagram): Reuse the exact same filename to overwrite it
   - **Different diagram**: Generate a new filename

### URL Safety

**NEVER** manually type, copy, or reproduce generated URLs in text responses. The URL contains compressed base64 data — even a single character change breaks it. Always let the Python script generate the URL and embed it directly in the HTML file.
