# CONTEXT.md: Bounce Back game jam project

A summary of everything known about this project so far. Paste it into any new chat or agent session so it can pick up where this one left off.

## 1. The situation

- Making a game in **Godot** to be hosted on **itch.io** for a **game jam**.
- **Theme:** *Bounce Back*. The user finds it deep and wants the game to reflect that.
- **Time limit:** 24 hours (about 1 hour had passed at the time of the later messages).
- **Team:** 3 members, all beginners. The user knows basic programming and finds Godot confusing at first.
- **Goal:** the best polished MVP they can finish. They asked for mistakes to be pointed out.
- The team has **someone confident with pixel art**.
- The user already has **idle animation PNG frames** for the character.
- Location context is not needed for this project.

## 2. What the user wants (stated)

- A game about a **teenage boy's life**, the hardships he faces, and how he bounces back.
- Something that is **interesting to play**, not only a story.
- The character should have **meaning**, not just be a body dodging hazards.
- A **GBA / Pokémon-style look** (top-down), but easy to make.
- **No jumping around.** The user said they don't want a platformer or Flappy Bird feel.
- **Core idea in their words:** when he fails he falls, and the player bounces him back.
- They said they were confused by the early plans and wanted something simple and clear.
- They said "something playable" when the plan felt too much like a story walkthrough.

## 3. Current plan (decided direction)

### Game summary
A short **top-down, GBA-style game** about one hard day in a teenage boy's life. 5 to 10 minutes long.

### How it plays
1. Walk with arrow keys (or WASD) and press **Space** near an NPC to talk.
2. A **sliding bar** moves back and forth. Press **Space** when it's in the green zone to say the right thing.
3. If you miss, the boy **falls**: the screen shakes and turns grey.
4. Mash **Space** to fill a bar and **bounce back**: he stands up with a "boing" and color returns.
5. Retry right away. Failing is forgiving, never harsh.

### Structure
- **3 places:** Home (morning), School (day), Rooftop (evening).
- **3 challenges**, all the same mini-game with different text and a slightly smaller green zone each time.
  - Home: tell mom about the test.
  - School: answer the teacher's question.
  - Rooftop: say sorry to his friend (final challenge).
- **Ending message:** "Tomorrow might be hard too. He'll bounce again." The ending should be honest, not unrealistically perfect.

### Story thread (suggested, not confirmed by the user)
One wound connects everything: a fight with his best friend, after which grades slipped and home got tense. The rooftop is where they used to hang out.

### Visual and feel ideas (suggested)
- Palette shifts from cold and dark (Home) to warm (Rooftop).
- Screen dims and music drops when he falls; colors brighten when he stands back up.
- Short, specific dialogue lines. Optional: two reply choices after a bounce that only change the next line.

### Scope
| Content | Amount |
|---|---|
| Playable character | 1 sprite, 4-direction walk, idle, fall, stand up |
| Maps | 3 small ones |
| NPCs | 3 to 4 (same sprite recolored) |
| Dialogue box | 1 reusable scene |
| Challenge mini-game | 1 scene, reused 3 times |
| Fall and bounce scene | 1 scene |
| Music | 1 or 2 loops |
| Screens | Title and ending |

**Cut list (do not build):** battles, inventory, save/load, menus, multiple endings, quests, multiple characters.

## 4. Technical decisions

- **Engine:** Godot 4.x (same exact release for everyone). GDScript.
- **Display:** viewport 240x160, window override 960x640, stretch mode `viewport`, default texture filter `Nearest`. Tiles and characters at 16x16.
- **Player:** `CharacterBody2D`, Motion Mode **Floating**, `Input.get_vector("ui_left","ui_right","ui_up","ui_down")`, speed about 80, `move_and_slide()`.
- **Sprite:** `AnimatedSprite2D` with SpriteFrames (animation names: `idle`, `walk_down`, `walk_up`, `walk_left`, `walk_right`, `fall`, `stand_up`).
- **Other nodes:** `Area2D` for NPC interaction, `CanvasLayer` for dialogue box and UI, `TileMapLayer` for maps, autoload `GameManager` for beats and scene switching.
- **Dialogue:** stored in `res://data/dialogue.json`, never hardcoded.
- **Export target:** HTML5 for itch.io. **Do a test web export early (before hour 4)** and again after big changes.

## 5. Team split (three lanes)

1. **Gameplay programmer:** movement, NPCs, dialogue box, challenge, bounce scene, GameManager, integration, export.
2. **Artist and UI:** boy sprite and animations, tileset, NPCs, title and ending screens, palette.
3. **Designer, writer, audio, QA, itch.io page:** dialogue, map layouts, difficulty tuning, music and SFX, playtesting, README, credits, page.

Rule: nobody edits another lane's files. Requests go in `HANDOFF.md`, bugs in `BUGS.md`. One integration owner (the programmer). The user is considering using AI agents for some of the work.

## 6. Timeline (24 hours)

| Hours | Goal |
|---|---|
| 0-1 | Lock plan and contracts |
| 1-4 | Player walks, NPC talks, web export test works |
| 4-9 | All 3 maps, challenge, bounce scene work with placeholder art |
| 9-15 | Real art, music, sound; dialogue final |
| **15** | **Feature freeze** |
| 15-22 | Playtest, fix bugs, itch.io page and screenshots |
| 22-24 | Final export, submit, buffer |

**Cut order if behind:** extra NPCs, music variety, walk animation polish, the second School knock-down. **Never cut:** the challenge, the fall and bounce-back scene, the ending.

## 7. History of ideas (how we got here)

1. **ChatGPT concept ("One More Step"):** a 3-chapter 2D platformer with a timed bounce mechanic. Problems: too much scope, vague, too many systems (3 levels, checkpoints, timing window, dialogue, palette shifts).
2. **Vertical bounce climber (Doodle Jump style):** auto-bounce, steer left and right, climb to a sunrise. Safe and easy, but the user wanted an RPG feel.
3. **Mario-style side-scroller:** stomp enemies to bounce, chain combos. More level design work.
4. **Pokémon-GBA-style top-down game:** strongest for story, riskiest for scope. Solution: copy the *look*, not the systems (no battles or inventory).
5. **Current choice:** top-down GBA-style walker with one sliding-bar challenge and a fall and bounce-back scene.

Also discussed: Godot vs GDevelop (GDevelop is a fallback if Godot proves too hard), RPG Maker, Ren'Py, Phaser. Godot was recommended because the user knows basic programming and wants itch.io web export.

## 8. Files already produced in this chat

- `README.md`: project README template with placeholders to fill in (jam name, links, team names, Godot version, credits).
- `AGENTS.md`: rules for humans and AI agents, shared contracts, and the three-lane task split.
- `CONTEXT.md`: this file.

Step-by-step help already given: Godot project settings for the GBA look, building the Player scene, the movement script, a first room (Home), and adding an idle animation with AnimatedSprite2D.

## 9. Open questions and next steps

- **Next build step:** an NPC with a dialogue box that starts the challenge.
- Then the sliding-bar challenge scene, then the fall and bounce-back scene, then the GameManager and map switching.
- Still undecided: the exact friend or family storyline, whether to include two reply choices after a bounce, the project name, and the final palette.
- Still to do: itch.io page description, `CREDITS.md`, `HANDOFF.md`, `BUGS.md`, and `dialogue.json` text.

## 10. Notes and warnings given

- Don't copy Pokémon or Nintendo names, sprites, music, or characters. Make original assets and credit any licensed ones.
- Test the web export early; browser builds can fail late.
- Don't let three people edit the same scene at once. Commit working versions often.
- Keep difficulty forgiving, because failing should be recoverable.
- Don't add new features after the freeze.
- If using AI agents, review and run every change before committing.
