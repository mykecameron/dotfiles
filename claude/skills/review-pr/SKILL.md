---
name: review-pr
description: Review someone else's PR with /code-review, then turn the findings into short inline GitHub comments in my voice. Use when the user gives a PR number to review.
argument-hint: <pr-number> [severities, e.g. "major minor"]
disable-model-invocation: true
---

Review PR $ARGUMENTS. The first token is the PR number. Any other tokens are severities to include (critical, major, minor, suggestion, observation). With no severities, include every finding.

1. Check out the PR in a worktree named `code-review-pr-<n>`: EnterWorktree, then `gh pr checkout <n>`. Read `gh pr view <n>` for the description and the linked ticket.
2. Run `/code-review` with the Skill tool against `main`. Write the review to `code-review-pr-<n>.md` in the main checkout root, not the worktree, so it survives worktree cleanup.
3. Turn each included finding into an inline comment. Check its line against `gh pr diff <n>`. GitHub only accepts inline comments on lines in the diff. If the line isn't in the diff, move the comment to the nearest changed line or make it file-level, and say which.
4. Append an `## Inline comments` section to the review file and print the same section in chat. Format each comment as:

   ````
   ### `path/to/file.rb:42` [MAJOR]

   comment body, ready to paste
   ````

   Use `` `path/to/file.rb` (file-level) `` when there is no line.
5. If there is a point that spans the whole PR, draft a top-level review body of one to three lines.
6. Never post anything to GitHub.

## How I write review comments

- Start lowercase. One to three sentences.
- Prefix `nit:` for minor findings and suggestions, `note:` for observations, nothing for major or critical. Use ⚠️ only when users could get hurt.
- Ask, don't order: "could we…?", "should we…?". Say so when I'm unsure ("unclear to me", "might be worth asking product").
- Lead with what breaks and when. Then the fix.
- Link to related code with a SHA permalink (`https://github.com/cartwheel-care/cartwheel/blob/<sha>/<path>#L<a>-L<b>`) instead of describing it.
- Add a ```` ```suggestion ```` block when the fix is a small edit to the commented lines.
- No headers, bold, or severity words in the body.

Examples of comments I've posted:

> should we check the flag here at run time? that way turning it off stops any jobs already enqueued? otherwise, if we need to turn it off, we'll have to dig into the scheduled set in redis or deploy a no-op job to consume whats been enqueued
>
> ```suggestion
>     def label!
>       return skip(:disabled) unless Flipper.enabled?(:cob_outreach_OCT_2026)
>       return skip(:resolved_or_reentered) unless still_open?
> ```

> note: this sends to a client once, ever. if we resolve a COB case and the same family is flagged again later, they won't get outreach. the linear issue highlights this in an open question that is unanswered, so maybe this is the desired behavior, unclear to me. just want to make sure this is deliberate and not going to turn into a bug!

> nit: [the CDP naming guide says to use snake_case keys here](https://github.com/cartwheel-care/cartwheel/blob/891bbb4760bddb9cb9abe9483e334db979be18a1/styleguide/cdp-naming-conventions.md?plain=1#L29-L52). they get [camelized before they're sent](https://github.com/cartwheel-care/cartwheel/blob/891bbb4760bddb9cb9abe9483e334db979be18a1/styleguide/cdp-naming-conventions.md?plain=1#L54-L56) so the payload still ends up camel case keyed

> 1000 tokens is roughly 4000 characters, but `GeneratedNoteValidator::MAX_LENGTH` is `2500`. anything longer gets marked `TOO_LONG`. the user still sees the note, but the Datadog metric and analytics event will count it as invalid. should we bump `MAX_LENGTH` [here](https://github.com/cartwheel-care/cartwheel/blob/d3843c8ce060c259188b814399f9f3190cb3bfda/app/services/wheelhouse/generated_note_validator.rb#L19) to match?
