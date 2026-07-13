---
inclusion: fileMatch
fileMatchPattern: "{Taskfile.yaml,.task/*.yaml}"
---

# Taskfile Conventions

## Structure

The task runner uses [Taskfile](https://taskfile.dev/) v3 with a modular layout:

- `Taskfile.yaml` - Root entrypoint defining top-level composite tasks
- `.task/*.yaml` - Individual task modules, one per tool or concern

All modules are included with `flatten: true` so tasks can reference each other directly without namespace prefixes.
Modules that operate on the `terraform/` directory set `dir: terraform` in their include block.

## File Conventions

- All Taskfile YAML files must start with `---`.
- Include the yaml-language-server schema comment:
  ```yaml
  # yaml-language-server: $schema=https://taskfile.dev/schema.json
  ```
- Use `version: 3` in every file.
- Validate all Taskfiles with `check-jsonschema` (vendor.taskfile schema).

## Task Naming

- Use colon-separated namespaces: `<tool>:<action>` (e.g. `terraform:fmt`, `yaml:lint`, `zizmor:workflows`).
- Internal subtasks use deeper nesting: `utils:pre-check:exec:*`.
- Provide `aliases` for commonly-used tasks (short forms like `t:f`, `t:v`).
- Use `desc` for a one-line description and `summary` for multi-line detail on every non-internal task.

## Common Patterns

### Argument ordering

Arguments for each task should be set in the following order, where used: `internal`, `aliaes`, `desc`, `summary`,
`sources`, `silent`, `run`, `deps`, `vars`, `env`, `preconditions`, `cmds`, `generates`, `status`. Any other arguments
should be placed after `status`.

Arguments for includes should be set in the following order, where used: `internal`, `dir`, `flatten`. Any other should
be placed after `flatten`.

### Silent execution

All tasks use `silent: true` to suppress command echoing. Output is controlled explicitly.

### Deferred error reporting

Use a `defer` block at the start of `cmds` to print a red "Failed" message on non-zero exit:

```yaml
cmds:
  - defer: "{{if .EXIT_CODE}}echo -e '\\e[1;31mFailed\\e[0m'{{end}}"
  - cmd: <actual command>
  - cmd: echo -e '\e[0;32mPassed\e[0m'
```

The final command prints green "Passed" or "Completed" on success.

Any other required `defer` commands (e.g. cleanup) should be placed after the first `defer` command.

### Colour conventions

- Green (`\e[0;32m`) - Passed / Completed
- Red (`\e[1;31m`) - Failed
- Yellow (`\e[0;33m`) - Skipped

### Source-based caching

Tasks use `sources` to declare file dependencies. Taskfile will skip re-runs when sources haven't changed (checksums
stored in `.task/checksum/`).

Use `exclude:` within sources to ignore generated directories and/or specific files like `terraform/.terraform/**` and
`.kiro/**`.

### Conditional execution

Use `if:` on commands to guard against missing files:

```yaml
- if: ls .github/workflows/*.yaml >/dev/null 2>&1
  cmd: actionlint ...
```

Or use `test -f` for single files:

```yaml
- if: "[ -f .github/dependabot.yaml ]"
  cmd: zizmor ...
```

### Run control

- `run: once` - For setup tasks that should only execute once per invocation (e.g. pre-checks, pre-commit install).
- `run: when_changed` - For expensive tasks that should only re-run when sources change (e.g. `terraform init`).

### Internal tasks

Mark helper/setup tasks as `internal: true` to hide them from `task --list`.

### Dynamic file discovery

Use shell `find` commands in `vars` to discover files dynamically, excluding selected directories where necessary, such
as `.kiro/` and `terraform/.terraform/`:

```yaml
vars:
  files:
    sh: |-
      find . \
           -type f \
           -not \
        \(     -path './.kiro/*' \
           -or -path './terraform/.terraform/*' \
        \) -and \
           -iname '*.yaml' \
           -print \
        2>/dev/null \
        | sed 's|^\./||' \
        | paste -sd' ' - \
      || true
```

### Dependencies and ordering

- Use `deps` for tasks that must be run before the current task (e.g. pre-checks, pre-commit install, `terraform:switch`).
- `cmds` are executed sequentially, so ordering of commands is important.
- Each `cmd` should be a single command. Using pipes and binary operators (`&&`, `||`) is discouraged, but not banned.
  Where possible, use multiple `cmd` entries with `if:` guards).

## Terraform Binary

Terraform is managed via `tfswitch`, which installs the correct version as a symlink at `.bin/terraform`. All Terraform
tasks reference this as `{{ .ROOT_DIR }}/.bin/terraform` rather than a system-installed binary.

Tasks that call Terraform depend on `terraform:switch` to ensure the correct version is available.

## Environment Variables

Terraform tasks set `TF_IN_AUTOMATION: "true"` to suppress interactive prompts and reduce output noise.

## Adding a New Task

When creating a new task module:

1. Create `.task/<tool>.yaml` with the schema comment and `version: 3`.
2. Add an include in `Taskfile.yaml` with `flatten: true`.
3. Follow the naming convention: `<tool>:<action>`.
4. Add `desc` and `summary` fields.
5. Use `silent: true` and the defer/colour pattern.
6. Define `sources` for cache correctness.
7. Evaluate the need for `preconditions`, and well as `status` and `generates` where sources may be missing or
   generated.
8. Add relevant `deps` for prerequisite tasks.
9. If the tool needs to be present in `$PATH`, add it to `utils:pre-checks` deps.
10. Run `task schema:taskfiles` to validate the new Taskfile against the schema.
