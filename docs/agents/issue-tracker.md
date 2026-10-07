# Issue tracker: GitHub

Issues and specs live in GitHub Issues for `LowkeyLab/nix`.
Use the `gh` CLI.

## Conventions

For `gh issue` commands, pass `--repo LowkeyLab/nix`.

- Create: `gh issue create --repo LowkeyLab/nix --title "..." --body-file <file>`
- Read: `gh issue view <number> --repo LowkeyLab/nix --comments`
- List: `gh issue list --repo LowkeyLab/nix --state open`, adding
  appropriate label and state filters.
- Comment: `gh issue comment <number> --repo LowkeyLab/nix --body-file <file>`
- Apply or remove labels: `gh issue edit <number> --repo LowkeyLab/nix
  --add-label "..."` or `--remove-label "..."`
- Close: `gh issue close <number> --repo LowkeyLab/nix --comment "..."`

Use a file containing actual newlines for multiline bodies.
For exhaustive issue discovery, use the paginated API:

```bash
gh api --paginate 'repos/LowkeyLab/nix/issues?state=open&per_page=100'
```

This endpoint also returns pull requests; exclude entries with a
`pull_request` field when collecting issues.

## Pull requests as a triage surface

**PRs as a request surface: no.**

## Skill operations

When a skill says "publish to the issue tracker", create a GitHub issue.
When it says "fetch the relevant ticket", read the issue with comments.

## Wayfinding operations

- Map: one issue labelled `wayfinder:map`, containing Notes,
  Decisions-so-far, and Fog.
- Child ticket: link it as a GitHub sub-issue. If unavailable, add it
  to the map's task list and put `Part of #<map>` in the child body.
  Use `wayfinder:<type>` labels for research, prototype, grilling, or task.
- Blocking: use native GitHub issue dependencies. Add an edge with
  `gh api --method POST repos/LowkeyLab/nix/issues/<child>/dependencies/blocked_by
  -F issue_id=<blocker-db-id>`. Obtain the database ID with
  `gh api repos/LowkeyLab/nix/issues/<blocker> --jq .id`.
  If dependencies are unavailable, use a `Blocked by: #<number>` line.
- Frontier: consider open children in map order; select the first with
  no assignee and no open blockers.
- Claim: assign the ticket with
  `gh issue edit <number> --repo LowkeyLab/nix --add-assignee @me`.
- Resolve: comment with the answer, close the child, then append a
  concise result and link to the map's Decisions-so-far.
