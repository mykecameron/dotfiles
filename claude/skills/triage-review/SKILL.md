---
name: triage-review
description: Triage a code-review markdown file. Decide which findings to fix, explain why the rest should not be fixed, plan fixes, and propose PR description notes for the skipped items. Use when the user gives a review file path and asks to triage it.
argument-hint: <path-to-review.md>
disable-model-invocation: true
---

Triage the review at $ARGUMENTS. If no path is given, use the newest code-review-*.md in the working directory or this session's job tmp directory.

1. Read the PR: `gh pr view` for the current description, `gh pr diff` for the change.
2. For each finding, check it against the code before ruling. Read the source, and reproduce the problem when you can. Don't take the reviewer's word for it.
3. Give me one table: finding, verdict (fix / skip / already handled), one-line reason. For each skip, say why it doesn't warrant a code change.
4. Write a plan file for the fixes and give me the path.
5. Draft additions to the PR description that cover each skipped finding, so future reviews either don't flag it or can respond to our reasoning. Skip anything the description already covers. Show me the draft. Don't edit the PR until I approve.
