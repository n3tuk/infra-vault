---
inclusion: fileMatch
fileMatchPattern: ".github/**"
---

# GitHub Actions and CI/CD Conventions

## Directory Structure

All GitHub configuration lives under `.github/`:

- `CODEOWNERS` - Code ownership (by default all files are owned by `@jonathanio`)
- `dependabot.yaml` - Dependabot configuration for automated dependency updates
- `mergify.yml` - Mergify rules for auto-approval and auto-merge
- `release-drafter.yaml` - Release notes drafting configuration
- `zizmor.yaml` - zizmor security scanner configuration

Workflow files go in `.github/workflows/` and action definitions in `.github/actions/` (if created).

## Workflow Standards

- All workflow YAML files must start with `---`.
- Include the yaml-language-server schema comment:
  ```yaml
  # yaml-language-server: $schema=https://www.schemastore.org/github-workflow.json
  ```
- Use double quotes for strings (consistent with project YAML conventions).
- Use pinned action versions (full SHA or exact version tag); Dependabot manages updates automatically.
- Prefer reusable workflows and composite actions over duplicated steps.
- Use `permissions` at the job level only, with least-privilege access, and remove all permissions at the workflow level
  (GitHub defaults to `contents: read` for workflows) using an empty `permissions:` block (e.g. `permissions: {}`).

## Security (zizmor)

zizmor scans workflows for security issues. Configuration in `.github/zizmor.yaml`:

- `dependabot-cooldown` is set to 3 days (reduced from the default 7 to allow faster dependency updates for
  non-mission-critical systems).
- All other rules use defaults.

Avoid common security pitfalls:

- Do not use `pull_request_target` with checkout of PR head without careful consideration.
- Do not inject untrusted input (issue titles, PR bodies, comments) directly into `run:` steps; use environment
  variables or intermediate files.
- Do not use overly permissive `permissions` (e.g. `contents: write` when only `contents: read` is needed).
- Pin third-party actions to full commit SHAs where possible.

Run `task zizmor:workflows` to scan workflows locally, and `task zizmor:dependabot` to scan Dependabot config.

## Linting (actionlint)

actionlint validates all workflow files. Configuration in `.actionlint.yaml` defines:

- Self-hosted runner labels (so actionlint recognises them as valid)
- Configuration variables (so `vars.*` references are not flagged as errors)

Run `task actionlint` to lint workflows locally.

## Dependabot

Dependabot is configured in `.github/dependabot.yaml` for three ecosystems:

| Ecosystem        | Directory    | Schedule | Prefix             |
|------------------|--------------|----------|--------------------|
| `pre-commit`     | `/`          | Daily    | `chore(pre-commit)`|
| `github-actions` | `/`          | Daily    | `chore(actions)`   |
| `terraform`      | `terraform/` | Daily    | `chore(terraform)` |

All ecosystems have a 3-day cooldown before updates are applied. GitHub Actions updates are grouped by dependency name.

## Mergify

Mergify (`.github/mergify.yml`) automates Dependabot PR handling:

- Auto-approves Dependabot PRs that are not behind `main`, not in conflict, and only contain commits from
  `dependabot[bot]` or `n3tuk-terraform-docs[bot]`.
- Auto-merges approved Dependabot PRs using the rebase method once they have linear history, at least one approval, no
  `force-ci-run` label, and no conflicts.

## Validation Workflow

After modifying files in `.github/`:

1. `task actionlint` - Lint workflow files.
2. `task zizmor:workflows` - Security scan workflows.
3. `task zizmor:dependabot` - Security scan Dependabot config.
4. `task zizmor:actions` - Security scan action definitions.

Or run `task analyse` to execute all static analysis tasks.
