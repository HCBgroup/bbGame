# Bounce Back

*A short top-down game about one hard day in a teenage boy's life.*

Made in **24 hours** for the **[Game Jam Name]** game jam.
**Theme:** Bounce Back
**Engine:** Godot 4.x
**Play it:** [itch.io link]

---

## About

He's had a rough week. Today he has to face his mom, his teacher, and the friend he stopped talking to.

Walk through his day, talk to the people in it, and try to say the right thing. When it goes wrong, he falls. Getting him back on his feet is up to you.

The game is about the idea that failing isn't the end. What matters is that he gets back up.

## How to play

1. Walk around and find the person you need to talk to.
2. Press **Space** near them to start a conversation.
3. A bar slides back and forth. Press **Space** when it's inside the green zone to say the right thing.
4. If you miss, he **falls**. The screen turns grey.
5. Mash **Space** to fill the bounce bar and help him **bounce back**.
6. Try again, then move on to the next place.

There are three places: **Home**, **School**, and the **Rooftop**. The whole game takes about 5 to 10 minutes.

## Controls

| Key | Action |
|---|---|
| Arrow keys / WASD | Walk |
| Space | Talk, confirm, and bounce back |
| Esc | Pause (if included) |

## Features

- Top-down, GBA-inspired pixel art
- Three short scenes with one challenge each
- A fall-and-bounce-back moment that ties directly to the theme
- Original music and sound effects (see credits)
- Plays in the browser

## Team

| Name | Role |
|---|---|
| [Name] | Programming |
| [Name] | Art and UI |
| [Name] | Design, writing, sound, and itch.io page |

## Built with

- [Godot Engine](https://godotengine.org/) 4.x (GDScript)
- Art made in [tool name]
- Audio made in or sourced from [tool/source]

## Running the project

**To play:** open the itch.io page and play in your browser.

**To open the project:**

1. Install the same Godot 4 version listed in `project.godot` (or in this README: **[version]**).
2. Clone or download this repository.
3. In Godot, click **Import** and select the `project.godot` file.
4. Press **F5** to run.

**To export for the web:**

1. Go to **Project > Export** and add a **Web** preset.
2. Export as `index.html`.
3. Zip the exported files and upload to itch.io, then tick **This file will be played in the browser**.

## Project structure

```
res://
├── scenes/      Player, maps, NPCs, dialogue box, challenge and bounce scenes
├── scripts/     GDScript files
├── assets/
│   ├── sprites/
│   ├── tiles/
│   ├── audio/
│   └── fonts/
└── ui/          Title and ending screens
```
