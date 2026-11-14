# AGENTS.md

Rules for every AI agent in this repository. This is a Hack Club Haven jam. The game is **Bounce Back**. Read [STORY.md](STORY.md) and [STORYBOARD.md](STORYBOARD.md) before any edit. Log every session in [AUDIT.md](AUDIT.md).

## Hack Club Haven, and how much AI a person may use

Source: the Haven FAQ, "Is AI allowed at Haven?" on [haven.hackclub.com](https://haven.hackclub.com/).

- AI-generated art, sprites, tiles, UI, and music are **not allowed**. Make them, or use a pack you credit. The Cute Fantasy files in `assets/other_itemas/` are a free non-commercial pack. Credit them if they ship. Do not redistribute that pack by itself.
- AI-assisted coding is **allowed but extremely discouraged**.
- Vibecoding the project is **not allowed**. Haven wants the crew's own work.
- The game that goes to itch.io must be playable in the browser, built at the jam, and credited. Put **HC** on the title and the ending: "HC — Hack Club Haven".

What that means for each person:

| Person | Initials to sign in AUDIT.md | AI pictures and audio | AI code | Limit |
| --- | --- | --- | --- | --- |
| Assets (you) | fill in, role tag ART | Never | Do not generate art files | Draw or place real files. You may ask an agent about layout using the storyboard panel ids. |
| Coder | fill in, role tag CODE | Never | Discouraged | Write the root game yourself. You may read `draft/` to see the intended loop. Do not paste the draft into the root and submit that as the jam game. |
| Music | fill in, role tag MUSIC | Never | Not your lane | Original loops and stings only, or a credited source. No generated audio. |

If a person uses an assistant anyway, they say so in `AUDIT.md` the same day: their initials, the tool, the files, what they kept, what they threw away, and that a human ran it. A session with no log does not get merged.

## What agents do

Agents follow the table above. They do not invent characters, endings, rooms, or quests. The people are Arun, Mom, Ms. Das, and Kabir. The only skill check is the sliding bar on storyboard panels B4 and C4.

An agent may:

- Edit `STORY.md` or `STORYBOARD.md` when a human asks, keeping `STORY.md` as the source of truth
- Edit `draft/` when a human asks for a prototype
- Append `AUDIT.md` whenever the agent changes any file

An agent may not:

- Edit root `scenes/`, root `scripts/`, root `project.godot`, or `assets/`
- Generate images, fonts, or audio anywhere
- Commit, push, or open a pull request unless a human explicitly asks
- Treat `draft/` as the game to export to itch.io

`draft/` is a colored-rectangle prototype of the MVP so the crew can play the loop. It is not the submission. The coder rebuilds that loop in the root project with the crew's art and music.

## Crew, and which files go to whom

Nobody edits another lane's files. Ask in person, then write the request at the top of `AUDIT.md` under Handoffs.

| Files | Written by | Sent to | What they do with them |
| --- | --- | --- | --- |
| `STORY.md`, `STORYBOARD.md` | Whoever the crew asks | ART, CODE, MUSIC, every agent | Follow them. Do not add beats. |
| `AGENTS.md`, `AUDIT.md` | Whoever changes process, plus every agent session | The whole crew, before the itch upload | Read the log. Do not ship a build the log cannot explain. |
| `assets/boy/`, `assets/tiles/`, `assets/ui/`, dressed map scenes | ART | CODE | Hook these paths. Do not redraw them. |
| `assets/audio/calm.ogg`, `fall.ogg`, `boing.ogg`, `success.ogg`, `miss.ogg` | MUSIC | CODE | Play these names. Do not replace the files. |
| Root `scripts/`, root `scenes/`, export preset, itch zip | CODE | ART and MUSIC for playtests, then itch.io | The only build that gets submitted. |
| `draft/` | A prototype, already logged | CODE, as a reference | Play it. Do not upload this folder. |
| `assets/other_itemas/` | Already in the repo (Cute Fantasy) | ART, if a tile is useful | Credit the pack on the itch page. |
| itch.io page, screenshots, credits | CODE uploads, ART supplies shots, MUSIC supplies credit lines | Judges and players | Browser build. Credit HC, the crew, and every pack. |

Credits block to copy onto the game and the itch page:

```
Bounce Back
HC — Hack Club Haven
Art: ART
Code: CODE
Music: MUSIC
Cute Fantasy asset pack, if those files are in the build
```

Replace ART, CODE, and MUSIC with real initials before you submit.

## Audit

Every agent, before it finishes, appends to `AUDIT.md`:

- Date and time
- Human who asked
- Tool
- Files touched
- Haven note: no new art or audio, and whether the edit was story, audit, or `draft/` only
- What a human still has to play or redraw

If you are unsure, stop. Ask which storyboard panel id they mean.
