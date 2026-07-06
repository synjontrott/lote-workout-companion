# Tickets

Product backlog for the **Legends of the Elsaither Workout Companion** (Flutter
app in `cross_platform_build/`). One Markdown file per ticket. This directory is
documentation only — it is outside the Flutter project root, so nothing here is
compiled into or shipped with the app.

There is intentionally **no index of tickets in this file** — an index has to be
hand-synced on every add/rename and rots. Find and filter tickets from the
filenames and frontmatter instead (see below).

## Adding a ticket

Create a file named with today's date and a short slug — no number lookup, no
collisions:

```sh
# from repo root
$EDITOR "tickets/$(date +%F)-short-slug.md"
```

Start it with YAML frontmatter, then the body:

```markdown
---
title: "Short human title"
status: open            # open | in-progress | done
category: "Workouts & Quests"
created: 2026-07-06
completed:              # fill in the date when status flips to done
---

## Description

What needs to happen and why.

## Technical Notes

(optional) file:line pointers, root-cause notes, etc.
```

When you finish a ticket, set `status: done` and fill `completed:`. Don't rename
or delete the file — the closed tickets are the project's history.

## Frontmatter fields

| Field       | Values                          | Notes                                  |
|-------------|---------------------------------|----------------------------------------|
| `title`     | quoted string                   | Human-readable summary                 |
| `status`    | `open` \| `in-progress` \| `done` | Current state                        |
| `severity`  | `critical` \| `high` \| `medium` \| `low` | Optional; use on bug tickets |
| `category`  | quoted string                   | e.g. Workouts & Quests, RPG & Gamification |
| `created`   | `YYYY-MM-DD`                    | When the ticket was raised             |
| `completed` | `YYYY-MM-DD` or empty          | When it was closed                     |

Bug tickets typically use body sections `## Symptom`, `## Repro`, `## Root
cause` (with `file:line`), and `## Suggested fix`.

## Finding tickets

```sh
cd tickets

ls 2026-07*                              # everything raised in July 2026
grep -l 'status: open' *.md              # all open tickets
grep -l 'category: "Workouts & Quests"' *.md   # by category
grep -rn 'stand goal' *.md               # full-text search
```

## History

Categories in use: Psychological Profiles & Onboarding, Notifications &
Scheduling, Workouts & Quests, Nutrition & Health, RPG & Gamification, Dynamic
Health Metrics.

The initial 28 tickets were migrated on **2026-07-02** from a single "Master List
of Tickets to be Resolved" checklist that used to live in `agents.md`. They share
`created: 2026-07-02` (the migration date; per-ticket creation dates were not
recorded in the original checklist) and `completed: 2026-07-06` (the day their
implementing commits landed). All 28 are `done`.
