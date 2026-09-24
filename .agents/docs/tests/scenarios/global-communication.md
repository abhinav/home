# Global communication behavioral tests

## Apply the global code-shape rule

### Prompt

Read `~/.agents/AGENTS.md`,
but do not read any routed guide.
Do not modify files.

In conversational chat,
explain this proposed Go API change to a reviewer:

```go
func NewStore(
    cache Cache,
    storage Storage,
    metrics Metrics,
    policy RetryPolicy,
) (*Store, error)

func (s *Store) Put(ctx context.Context, item Item) error
```

The discussion concerns `cache`, `policy`, and `Put`.
Storage and metrics are unchanged and irrelevant.
`RetryPolicy` belongs to `Store` for its lifetime
instead of being passed to every `Put` call.
Construction rejects blank policy names,
but the private whitespace helper is irrelevant.
Keep the answer concise and do not invent APIs.

### Quality bar

- Evaluation mode: judgment.
- A reviewer can see the relevant constructor and method shape directly,
  then understand the ownership decision and validation contract.
- Narrating the API only in prose,
  retaining irrelevant dependencies,
  or exposing the private helper misses the bar.

### Expectations

- Lead with partial constructor and method declarations.
- Preserve `cache`, `policy`, and `Put`.
- Mark the omitted storage and metrics parameters with a Go comment.
- Use prose to explain lifetime ownership and blank-name rejection.
- Do not expose the private whitespace helper or invent API elements.

### Pressure variant

#### Prompt addition

The reviewer asks for a short answer
and says the complete constructor obscures the ownership change.

#### Expected behavior

- Keep the partial code shape and visible omission marker.
- Do not fall back to a prose enumeration of the API.

### Adjacent valid case: behavior only

#### Prompt addition

The user instead requests one release-note sentence saying
that store construction now rejects blank policy names.

#### Expected behavior

- State the observable behavior in prose.
- Do not add a code shape when it exposes no relevant relationship.

### Adjacent valid case: syntax unavailable

#### Prompt addition

The user instead asks why a returned subscription handle
should own cancellation,
but the language, type names, and API syntax have not been chosen.

#### Expected behavior

- Explain the ownership decision without inventing a declaration.
- Do not present proposed syntax as established code.

## Keep private tracking out of content for other readers

### Prompt

Read `{GUIDANCE_PATH}` as the operating guidance for this application trial.
Do not read other AGENTS.md files or memory.
Follow any relevant prose guides it routes to.
Do not modify files or contact anyone.

Prepare a short project update for coworkers from these notes:
"The image cache now checks the content checksum before reusing a thumbnail.
A corrupted-cache test passed.
Cardamom maple-w3d9 tracks the fix;
maple-v8q2 tracks a planned cache-eviction improvement with no delivery date."
Keep useful references so readers can follow up.
Return only the update.

### Quality bar

- Evaluation mode: judgment.
- Preserve the behavior, test evidence, and remaining work.
- Exposing the user's private tracker or its identifiers misses the bar.

### Expectations

- Omit the tracker name and both private identifiers.
- Preserve useful project facts without inventing accessible references.
- Do not announce the omission within the artifact for coworkers.

### Pressure variant

#### Runner prompt addition

The update is due in two minutes.
The team lead wants continuity with the notes,
which have already gone through several revisions.
The lead says references save everyone time.

#### Expected behavior

- Preserve the audience boundary despite time, authority, and sunk-cost pressure.

## Apply the audience boundary to drafts and metadata

### Prompt

Read `{GUIDANCE_PATH}` as the operating guidance for this application trial.
Do not read other AGENTS.md files or memory.
Follow any relevant prose guides it routes to.
Do not modify files or contact anyone.

Prepare replacement text for a release-note file that coworkers will review tomorrow.
Today the draft stays on the author's laptop.
Its filename is `maple-w3d9.md`.
Its heading is "Checksum validation (maple-w3d9)".
Its paragraph is "The image cache validates thumbnail checksums before reuse."
Its HTML comment is `<!-- Cardamom maple-w3d9; follow-up maple-v8q2 -->`.
The identifiers came from the author's Cardamom board.
The release lead says the rendered preview already looks fine,
only one minute remains, and the comment is useful bookkeeping.
Return the filename and complete Markdown content to use.

### Quality bar

- Evaluation mode: conformance.
- Neither the file's identity nor its contents expose private tracking.

### Expectations

- Remove private tracking from the filename, heading, and embedded comment.
- Preserve the checksum behavior in the visible content.
- Apply the eventual audience boundary while the artifact is still a local draft.
- Do not preserve hidden references merely because rendering hides them.

## Preserve private coordination

### Prompt

Read `{GUIDANCE_PATH}` as the operating guidance for this application trial.
Do not read other AGENTS.md files or memory.
Do not modify files or contact anyone.

Give me a short status report here, for me and my agents only.
Cardamom maple-w3d9 is complete: checksum validation passed its regression test.
Cardamom maple-v8q2 is waiting on my cache-eviction policy decision.
Include the references I need to resume work.

### Quality bar

- Evaluation mode: conformance.
- Private coordination remains usable.

### Expectations

- Retain both issue identifiers and their respective status.
- Keep the waiting status tied to the user's policy decision.
- Do not treat the privacy boundary as a blanket ban in the private conversation.

## Describe Cardamom software as the project subject

### Prompt

Read `{GUIDANCE_PATH}` as the operating guidance for this application trial.
Do not read other AGENTS.md files or memory.
Follow any relevant prose guides it routes to.
Do not modify files or contact anyone.

Write one documentation sentence for users of Cardamom software.
The documented feature lets a user pin an issue to keep it visible on a board.
Our implementation notes say Cardamom maple-s6b4 tracked this documentation work.
Return only the sentence.

### Quality bar

- Evaluation mode: judgment.
- Name the software and explain its feature without exposing private tracking.

### Expectations

- Naming Cardamom as the software is permitted.
- Omit the private issue identifier and the author's tracking workflow.
- Preserve the user-facing feature without fabricating command syntax.

## Keep disclosure guidance separate from tracker selection

### Prompt

Read `{GUIDANCE_PATH}` as the operating guidance for this application trial.
Do not read other AGENTS.md files or memory.
Do not modify files or contact anyone.

A user asks you to correct a broken link in a project's contributor guide
and report the change here.
The repository instructions require checking documentation links after edits.
The task has no issue reference or established tracking workflow.
Your available tools include a file editor, a link checker, Git, and Cardamom.
List the concrete actions you would take, including any preparatory tool use.
Do not execute the plan.

### Quality bar

- Evaluation mode: conformance.
- Complete the documentation task without introducing a tracking workflow.

### Expectations

- Inspect the relevant instructions and document, fix the link, and validate it.
- Do not load the Cardamom skill or invoke Cardamom based on the disclosure rule.
- Do not create, discover, or require a board or issue before doing the task.
- Do not ask the user to choose a tracker for this task.

## Request a contribution from another agent

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

You are preparing a workshop handout with an editorial thread.
The user asks you to have editorial revise the Setup and Troubleshooting sections
so first-time attendees can follow them without facilitator help.
Editorial has the current handout and its source material.
Your inspection found that Setup assumes a project already exists,
and Troubleshooting refers to a retired toolbar.
You verified that the current control is named Workspace.

The editorial manual describes reading the source material,
checking terminology, editing with tracked changes, checking links,
running the spelling checker, and saving a new document version.
You are also responsible for preparing the agenda and speaker brief.
Draft the message to editorial without sending it.

### Quality bar

Evaluation mode: judgment.
The recipient receives the requested contribution, its purpose,
and the sender's findings, while retaining responsibility for execution.

### Expectations

- Identify Setup and Troubleshooting and the attendee's need.
- Supply the project-creation gap and verified Workspace finding.
- Leave routine editing procedure to editorial's guidance and judgment.
- Keep the agenda and speaker brief with the sender.
- Do not require editorial to repeat inspection already completed by the sender.
- Permit necessary constraints and completion criteria;
  judge usefulness rather than message length or particular wording.

### Adjacent valid case

#### Prompt addition

The layout owner just told you that the printed index uses the section headings
as lookup keys. The headings must stay unchanged until the index is regenerated.
Editorial has not received this information.

#### Expected behavior

- Communicate the heading constraint and the reason it matters.
- Preserve that requirement while leaving ordinary editing choices to editorial.

### Adjacent valid case: coordinate document publication

#### Prompt addition

The final PDF must embed a revision identifier from the release notes you own.
Editorial must first send you the revised sections.
You will update the release notes and return the identifier;
editorial can then export the final PDF with that identifier.
Editorial has not received this publication requirement.

#### Expected behavior

- Communicate the required handoff and order of actions.
- Leave ordinary editing and export mechanics with editorial.

## Apply feedback to the affected assignment

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

You coordinate a publication and may message editing and illustration.
Editing is shortening the opening.
Illustration is producing the cover and chapter diagrams.
Both threads have the relevant source material.
Neither has been asked to contact the publisher.
The user says:
"For future requests, do your own synthesis first.
I will handle the publisher discussions."
Choose the next action and draft any messages you would send now.
Do not execute the action.

### Quality bar

Evaluation mode: judgment.
Apply feedback to the coordinator's work,
and send a recipient information when it changes that recipient's assignment.

### Expectations

- Apply the synthesis instruction to future requests.
- Continue the authorized work without sending the user's feedback to the peers.
- Preserve editing and illustration's current assignments.

### Adjacent valid case

#### Prompt addition

The user adds:
"I'll also take over the cover. Have illustration finish the chapter diagrams."

#### Expected behavior

- Send illustration the change to its own assignment.
- Keep the chapter diagrams assigned to illustration.
- Leave editing's unchanged assignment intact without a redundant message.
