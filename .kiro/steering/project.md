# Project Standards

## Overview

This is the `infra-vault` repository under the `n3tuk` organisation. It manages HashiCorp Vault (using the OpenBao fork)
infrastructure configuration using Terraform.

## File Formatting

- Use UTF-8 encoding for all files.
- Use LF (Unix) line endings.
- End all files with a single trailing newline.
- Trim trailing whitespace on all lines.
- Maximum line length is 120 characters.
- Use 2-space indentation for all files (except Go files which use tabs, and Dockerfiles which use 4 spaces).

## YAML Conventions

- Always start YAML files with the document start marker (`---`).
- Use double quotes for strings (only when quoting is needed).
- Do not use flow-style mappings (`{}`) or sequences (`[]`) for non-empty
  collections; use block style instead.
- Indent sequences consistently with their parent mapping.
- Add a `yaml-language-server` schema comment where a schema is available:
  ```yaml
  # yaml-language-server: $schema=https://...
  ```

## Markdown Conventions

- Maximum line length for prose is 120 characters; headings are limited to 80
  characters.
- Do not use hard tabs in Markdown files.
- Bare URLs are allowed (no need to wrap in angle brackets).
- Allowed inline HTML elements: `<a>`, `<pre>`, `<br>`.

## Commit Messages

- Follow [Conventional Commits](https://www.conventionalcommits.org/) format.
- Use scoped prefixes matching the area of change:
  - `chore(pre-commit):` for pre-commit hook updates
  - `chore(actions):` for GitHub Actions updates
  - `chore(terraform):` for Terraform provider/dependency updates
  - `feat(vault):`, `fix(vault):`, etc. for feature work and bug fixes
- Keep the subject line concise (72 characters max).
- Use the imperative mood in the subject (e.g. "Add", not "Added" or "Adds").

## Task Runner

This project uses [Taskfile](https://taskfile.dev/) (v3) for task orchestration.
The main tasks are:

- `task develop` (alias: `task d`) - Run all lint, format, validate, analyse,
  and documentation tasks (supports `--watch`).
- `task lint` - Lint Terraform, YAML, and Markdown files.
- `task formatting` - Format files with Prettier and `terraform fmt`.
- `task validate` - Validate Terraform and check YAML schemas.
- `task analyse` - Run Snyk, actionlint, and zizmor static analysis.
- `task documentation` - Regenerate terraform-docs output.
- `task clean` - Remove temporary/generated files.

Always run `task develop` (or the relevant sub-task) after making changes to
verify correctness before committing.

## Pre-commit Hooks

Pre-commit hooks are configured and must pass before commits are accepted. They
cover:

- Branch protection (no direct commits to main/master)
- Merge conflict markers
- Large file detection
- Secret scanning (gitleaks)
- Terraform formatting, validation, linting, lock file, and documentation
- Prettier formatting (Markdown, JSON, YAML)
- yamllint and markdownlint
- JSON schema validation (Taskfiles, Dependabot, GitHub Workflows/Actions,
  Mergify)
- actionlint and zizmor for GitHub Actions security

## Dependencies

- Dependabot is configured for `pre-commit`, `github-actions`, and `terraform`
  ecosystems with daily checks and a 3-day cooldown.
- Mergify auto-approves and auto-merges Dependabot PRs that pass CI and remain
  conflict-free.

## Security

- Never commit secrets, keys, or credentials (enforced by gitleaks).
- Snyk scans Terraform for misconfigurations.
- zizmor scans GitHub workflows for security issues.
