# Contributing to n3t.uk Repositories

[`n3tuk`][n3tuk] is a personal GitHub Organisation which contains a collection
of configurations and services for personal development, alongside the operation
of personal systems. As such, much of the code and configuration therein is
highly opinionated based on my own needs and ideas, or as part of testing and
development of resources.

[n3tuk]: https://github.com/n3tuk

This guide provides help on how to work with and develop for this repository,
including the tooling needed and expected practices around naming, files,
variables, etc..

## Tooling

There are four main tools used to manage code quality as well as operate
automations and deployments:

1. [`pre-commit`](#pre-commit)
1. [`task`](#task)
1. [GitHub Workflows](#github-workflows)
1. [Dependabot](#dependabot)

### `pre-commit`

This repository uses the [`pre-commit`][pre-commit] tool to provide a set of
common and specific steps with an expectation to run these before committing any
code to this repository:

[pre-commit]: https://pre-commit.com

```sh
$ sudo pacman -S python-pre-commit
$ pre-commit --install
pre-commit installed at .git/hooks/pre-commit
```

This includes:

- Checking that the file names are compatible with all operating systems;
- Checking that large files are not staged and committed;
- Checking that files do not contain trailing spaces and have new lines at the
  end of the file;
- Documentation doesn't have any bad links;
- That YAML, JSON, and Markdown files are valid; and
- Any local application-specific code or configurations are correct and valid.

I **strongly** recommend using it as it provides useful fast feedback on any
changes before committing and pushing them up to the repository branch. As there
is no way to automatically install `pre-commit` upon cloning this repository
(`init-templatedir` aside), the `task` tooling works to check this installation
of `pre-commit` whenever used.

### `task`

This repository also uses the [`task`][taskfile] tooling from
[Taskfile][taskfile] to provide the automation of standard tasks and checks:

[taskfile]: https://taskfile.dev/

To use [Taskfile][taskfile], you can run `task` from the command-line:

```sh
$ task --list
task: Available tasks for this project:
(...)
```

`task` becomes even more useful when paired with the `--watch` command-line
flags, allowing it to run the requested tasks, and then check files for changes,
triggering each task as needed. For example, this allows for automated updates
of the documentation for Terraform as you write the Terraform configuration, or
to run tests and linters for Go source code as you write an application.

```sh
$ task --watch
task: Started watching for tasks: default
(...)
```

### Dependabot

[Dependabot][dependabot] is a code security analysis tool provided by GitHub to
automate the scanning of versions in supported codebases, and provide automated
Pull Requests to increase the version one a dependency either based on a new
release, or an identified security issue.

[dependabot]: https://docs.github.com/en/code-security/dependabot

[`.github/dependabot.yaml`](dependabot.yaml) holds the configuration for
Dependabot in this repository, and defines what types of checks are run, and
when.

### GitHub Workflows

[GitHub Workflows][github-workflows] are the primary CI/CD mechanism for all
repositories inside `n3tuk`. All workflows for this repository are available in
the [`.github/workflows/`](workflows) directory.

[github-workflows]: https://docs.github.com/en/actions/using-workflows

#### `force-ci-run` Label

GitHub Workflows have an issue when it comes to checking and committing changes
which it itself has authored: [These changes cannot trigger GitHub Workflows
themselves][token-in-workflow], as so to prevent infinite loops. Although a full
Personal Access Token can support this, creating PATs for each repository and
managing their scopes is difficult and it presents a wider security risk.

[token-in-workflow]: https://docs.github.com/en/actions/security-guides/automatic-token-authentication#using-the-github_token-in-a-workflow

As such, this repository has a setting to allow forcing a CI run by using a
label: `force-ci-run`. So, for example, if [`dependabot`](#dependabot) makes an
update to a module or package, there could be a change to the documentation
which is automatically generated and committed within a GitHub Workflow.

Once committed and pushed up to the Pull Request, GitHub will not trigger
further runs of any Workflows, preventing approval of the Pull Request.

By adding the label `force-ci-run` (which in turn the GitHub Workflows will
remove one triggered), you can forcefully run all the GitHub Workflow listing
for that label and get the results without having to explicitly commit and push
any code changes yourself.

## Committing Changes

This repository operates mainly on the [GitHub Flow][github-flow] model, with
the expectation to make a change a feature branch (in _draft_ mode, or with the
`work-in-progress` label, if under active development). Upon each commit, the
configured GitHub Workflows, plus any connected third-party status checks, will
run, checking code changes.

If all these pass (and an approved review, if required), merging the code to the
default branch (`main`) using a [_Rebase Merge_][rebase-merge] will be
available. All `n3tuk` repositories have _Merge_ and _Squash Merge_ options
disabled to keep the history linear, and enforce signed commits.

[github-flow]: https://docs.github.com/en/get-started/quickstart/github-flow
[rebase-merge]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/about-merge-methods-on-github#rebasing-and-merging-your-commits

### Committing Standards

A commit message should be a statement of what the **commit** will do once
applied, not what **you** have done in writing it, and as such it must be
imperative. Use the present tense (_change_, not _changes_ or _changed_) for the
message, and cover the what/why, but not the how.

#### Rules

- Commit messages must have a subject line as the first line. It may have body
  copy where the subject line does not convey the reasoning enough. A blink line
  must separate these.
- The subject line must not exceed 50 characters and must not end in a period.
- Capitalize the first word of the subject line.
- Write the subject line in an imperative mood (_Fix_, not _Fixed_ or _Fixes_).
- Wrap the body copy at 72 columns.
- The body copy should extend to the what and the why of the commit, never the
  how. The latter belongs in documentation and implementation.

> **Warning**
> By limited the use of the Pull Request description to link to issues and other
> Pull Requests, it eliminates the duplication of the message when rebasing or
> refactoring code.

### Pull Request Standards

A Pull Request will be a set of one or more commits which handle a focused,
concise change to the codebase. As this repository operates on a GitHub Flow
basis, there is no need for branch name prefixes, such as `fix/` or `feature/`.

The name of the branch should be a concise name of the change in the pull
request in [snake case][snake-case], such as `refactor-the-example-type` or
`fix-hostname-in-ec2-instance`.

The title and description of the Pull Request should be concise and follow the
same guidelines as the [Committing Standards](#committing-standards) above, with
links to other Pull Requests or Issues in this or other repositories linked in
the Pull Request, rather than the commit. For example:

```markdown
Resolves: #123
See also: #456, #789
```

> **Note**
> By limited the use of the Pull Request description to link to Issues and other
> Pull Requests, it eliminates the duplication of the message when rebasing or
> refactoring code before merging.

## Naming Conventions

The requirements for the naming of resources is as follows. In all cases the
naming should be in lower-case.

| Resource&nbsp;Identifier&nbsp;Name | Use&nbsp;Case&nbsp;Type    | Notes                                                                                                                                                      |
| :--------------------------------- | :------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `{terraform-filename}`             | [`kebab-case`][kebab-case] | (None)                                                                                                                                                     |
| `{terraform-resource}`             | [`snake-case`][snake-case] | (None)                                                                                                                                                     |
| `{terraform-variables}`            | [`snake-case`][snake-case] | (None)                                                                                                                                                     |
| `{terraform-outputs}`              | [`snake-case`][snake-case] | (None)                                                                                                                                                     |
| `{aws-resource}`                   | [`kebab-case`][kebab-case] | Although services support ranges of characters and cases, bar some small edge-cases, the most common case which works across all services is `kebab-case`. |
| `{tfc-resource}`                   | [`kebab-case`][kebab-case] | (None)                                                                                                                                                     |

[kebab-case]: https://en.wikipedia.org/wiki/Letter_case#Kebab_case
[snake-case]: https://en.wikipedia.org/wiki/Snake_case
