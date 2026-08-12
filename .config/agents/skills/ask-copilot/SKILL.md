---
name: ask-copilot
description: Runs a separate Copilot CLI process for a second opinion on a decision, or as a cheap subagent for bulky work. Use before a significant approach is settled, or instead of reading pages and long output here.
---

<!--
Example prompts:
  /ask-copilot Review my implementation plan
  /ask-copilot Is this the right approach for error handling?
-->

# Ask Copilot

Two jobs, one flag: `-p`/`--prompt` runs a prompt non-interactively and exits.
There is no `copilot exec` subcommand — `copilot` itself is the whole CLI, and
`-p` is what makes it non-interactive. Both jobs take a self-contained prompt:
the spawned Copilot process sees none of this conversation, so whatever it
cannot infer has to be in the prompt.

## Second opinion

```sh
copilot -p "<question>" --allow-all-tools -s
```

Leave the effort level alone (or set `--effort high`/`--effort xhigh` for a
harder question) — a rushed answer isn't worth having. Treat the reply as one
data point: compare it against your own reading of the codebase, report both
views to the user with the disagreements intact, and prefer established
project patterns where they conflict.

## Delegated grunt work

```sh
copilot -p "<task>" --allow-all-tools -s --model <model>
```

For work whose output is bulky but whose conclusion is small: web search, page
reading, codebase investigation, summarising long output, drafting a commit
message from a diff. A cheap model is the point — pick one with `--model
<model>` (or leave it unset to use the configured default; `/model` inside an
interactive session lists what's available). `-s`/`--silent` prints only the
agent's final response, dropping the stats footer, which is what you want when
capturing output for further use. `copilot --help` and `copilot help
<topic>` (e.g. `environment`, `permissions`, `sandbox`) carry the rest;
`--add-dir <path>` widens which directories it may touch beyond the repo root.

Measured, and not visible in the help output:

- Keep `--effort` at `medium` or above for anything that depends on current
  facts. At `low`/`minimal` it can answer from stale training knowledge instead
  of actually checking.
- `--allow-all-tools` is required for `-p` to do anything beyond talk — without
  it, every tool call blocks on a confirmation prompt that never comes in
  non-interactive mode.
- Command sandboxing (`copilot help sandbox`) is off by default: shell commands
  the spawned process runs have the same filesystem and network access as this
  session. It's an experimental, session-scoped opt-in (`--experimental` +
  `/sandbox enable`), not something to reach for from a one-shot `-p` call.
- Web search and page fetching are built into the CLI's own tools; no external
  search binary or extra PATH setup is needed.

Briefing it:

- Say which facts to return, and demand a citation for each — a URL, or a
  `file:line`.
- Ask for verbatim quotes wherever exact spelling matters: API options, flags,
  version numbers. A digest paraphrases them away.
