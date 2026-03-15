# Maglev v3: Draft and Published Page Workflow

## Overview

Maglev v3 introduces an explicit content lifecycle for pages:

- `draft`: the editable working version
- `published`: the public version visible to visitors

This lifecycle is a direct consequence of the v3 server-side editor architecture.

## Why this is required in v3

In a fully server-side editor, content updates pass through Rails requests and persistence layers.  
Without a lifecycle boundary, every edit could immediately affect the live site.

The `draft`/`published` split solves this by separating:

- Ongoing editorial work
- Public delivery of approved content

## Technical model

At a high level, each page has:

- A **draft state** updated by editor actions
- A **published state** served on the public frontend

Core rules:

1. Editing in admin updates the draft state.
2. Public requests resolve to the published state.
3. A publish action promotes draft content to published content.

Depending on implementation details, this can be backed by version records, snapshots, or state pointers.  
The important contract is always the same: **write to draft, read from published**.

## Request flow implications

### In the editor

- Editor endpoints operate on draft data.
- Preview capabilities can render draft content for authorized users.
- Autosave and manual save both target draft state.

### On the public site

- Visitor-facing endpoints resolve only published content.
- In-progress edits are isolated from public traffic.
- Publishing acts as the controlled synchronization point.

## Publishing semantics

Publishing is a deliberate operation, not a side effect of editing.

Typical behavior:

- Draft changes accumulate during editing sessions.
- User validates content (preview, QA, review).
- User triggers publish.
- Published state updates atomically for visitors.

This reduces accidental regressions and makes release timing explicit.

## User-facing meaning

For content teams, the model is simple:

1. Edit safely in draft
2. Review and validate
3. Publish when ready

Practical benefits:

- No accidental live edits
- Better collaboration between editors and reviewers
- Predictable release windows for campaigns and announcements
- Clearer accountability on who made content live

## Permissions and workflow design

The lifecycle also enables cleaner role-based workflows, for example:

- Some users can edit drafts but not publish
- Publishing can be limited to approvers/admins

Even without full editorial workflows, separating draft from published creates a safer default for all teams.

## Edge cases to document in product behavior

In Maglev v3, the behavior is:

- Page URLs come in two flavors: `preview` (draft) and `live` (published, when available).
- Unpublished pages return a `404` on the public side.
- Once a page has been published, it cannot be unpublished in this version.
- There is no publish history/rollback yet. However, you can discard current draft changes and return to the latest published version.
- Publish operates per page. Publishing a page also publishes the content of site-scoped sections used by that page.
