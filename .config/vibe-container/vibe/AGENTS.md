# Delegation guidance

Two local subagents are available, each pinned to its own model served by the
local vllm-mlx server (127.0.0.1:8080). Spawn them with `agents_spawn` using
their `config_name`:

- `coder` (model `local-code`): delegate all code work — reading, editing,
  running, and testing code. Spawn it for any task that involves writing or
  modifying code, and report its verified output to the user.
- `tutor` (model `local-study`): delegate study and explanation tasks — when
  the user provides material to learn from, asks for explanations, questions,
  or new worked examples.

Rules:
- Prefer spawning the matching subagent over doing the work yourself when the
  task clearly fits one of the two personas.
- Do not spawn both for the same task; pick the one that fits.
- Note that switching the local model takes ~30-60s on first load, so batch
  related subtasks into one subagent call.
