---
name: create-pr
description: Runs the full PR workflow — creates a feature branch, commits, pushes, and opens the pull request. Use when the user asks to create or open a PR ("create a PR", "push this up and open a PR").
---

# Create PR

Use this skill when the user asks to create or open a pull request.

## PR Granularity

A PR is a reviewable responsibility unit; one PR may contain multiple atomic commits. A branch is not a PR boundary: split independent work into separate PRs and stack only dependent work.

## Workflow

1. Inspect the current branch, status, and diff:

   ```sh
   git status --short
   git branch --show-current
   git diff --stat
   ```

   Determine the repository's default branch (do not assume `main`):

   ```sh
   gh repo view --json defaultBranchRef -q .defaultBranchRef.name
   ```

2. If the current branch is the default branch, create a feature branch with a `feature/`, `fix/`, or `chore/` prefix unless the user requested a different branch name.

3. Review the diff before committing. Exclude unrelated changes, temporary files, secrets, generated junk, and debug-only edits.

4. Commit with the repo-local `commit` skill using an English Conventional Commit message. When CI is unnecessary and repository instructions permit skipping it, append `[ci skip]` to the commit message.

5. Prepare a PR title and body proportional to the change:

   - Use a Conventional Commit type such as `feat`, `fix`, `docs`, `refactor`, or `chore` in the PR title.
   - Check for a repository PR template (`.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, or `.github/PULL_REQUEST_TEMPLATE/*.md`). If one exists, fill it in following its structure and headings instead of freeform prose.
   - When no template exists: for a small focused change, use 2–4 sentences covering what changed and why; for a larger change, include Summary, What Changed, Why, and Testing only when tests were actually run, and add Related Issues only when relevant.
   - Use `--body-file -` for multi-line bodies. Do not embed `\n` escape sequences in `--body`.

6. Before publishing, check whether a PR already exists for this branch to avoid creating a duplicate:

   ```sh
   gh pr list --head <branch-name> --state all
   ```

   If one exists and is open, report its URL instead of creating a new one. If a closed/merged PR exists for the same branch name, confirm with the user before proceeding.

7. Determine the base branch:

   - Default to the repository's default branch unless the work depends on another unmerged branch (e.g. stacked work), in which case pass `--base <parent-branch>` explicitly.

8. Determine draft vs ready-for-review:

   - Use `--draft` when the user asks for a draft, or when the work is intentionally incomplete/WIP. Otherwise open it ready for review.

9. Publish using the path that matches the PR structure:

   - Use `gh-stack` only when requested or when the branch is already part of a tracked stack; verify parent-child ancestry with `gh stack view` before linking, then push and link PRs with `gh stack push` / `gh stack submit`.
   - For an ordinary PR, push the branch and create the PR, piping the body into `--body-file -` via a heredoc so the command never waits on an unconnected stdin:

     ```sh
     git push -u origin <branch-name>
     gh pr create --title "feat(scope): summary" --base <base-branch> --body-file - <<'EOF'
     PR body goes here.
     EOF
     ```

     Add `--draft` to the `gh pr create` command when step 8 determined the PR should be a draft.

10. Report the PR URL. If publishing fails, inspect the error and verify the branch, remote, authentication, or duplicate PR state before retrying.

All commit messages, PR titles, and PR bodies must be in English. Confirm the target branch before creating the PR, and do not call it ready until the relevant checks and review feedback have been inspected.
