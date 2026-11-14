# Bounce Back — scene split

Five scenes. Three people. Use the files named here. Do not hunt for new packs today.

Story stays in [STORY.md](STORY.md). Panel order stays in [STORYBOARD.md](STORYBOARD.md). This file only says who builds each scene and which picture to drop in.

The boy drawings in `assets/boy/` are big front-facing portraits. They are his face in the dialogue box and on the title. They are not a walk cycle. The walking body is the Cute Fantasy sheet `assets/other_itemas/Player/Player.png` (four directions, plus a frame where he is down). Credit that pack on the itch page if it ships. It is free for non-commercial use. Do not use the slime, skeleton, or animals.

Anything marked **draw** does not exist in the repo. ART makes a small original sprite. No generated images.

## Who owns what in every scene

| Lane | Always |
| --- | --- |
| ART | The room look, the portraits, and the few props marked draw. Do not edit scripts. |
| CODE | The scene file, collision, Space spots, doors, the bar, and the fall. Do not redraw files. |
| MUSIC | One loop or sting per scene, dropped in `assets/audio/` under the name below. Do not edit scenes. |

CODE builds the shared pieces once, then copies them into the rooms: `scenes/player.tscn`, `scenes/ui/dialogue.tscn`, `scenes/ui/bar.tscn`, `scenes/ui/fall.tscn`.

## 1. Title — `scenes/title.tscn`

**Idea.** Black screen, his face, the name, and HC. Space starts the house. No walking.

| Lane | Do this |
| --- | --- |
| ART | Place `assets/boy/Idle/frame-1.png` big in the middle. That is enough. |
| CODE | Title scene. Space loads `scenes/house.tscn`. Text: BOUNCE BACK, then HC — Hack Club Haven. |
| MUSIC | No loop. Optional one-second tone named `assets/audio/title.ogg`. Silence is fine. |

## 2. House, morning — `scenes/house.tscn`

Panels A1 to A5. He wakes, gets ready, lies by not answering Mom, and leaves.

**Idea.** One dim room. Bed on the left, mirror under a window, bag on a chair, shoes by the door, Mom in the kitchen with keys. The bag looks empty. The door does not open until mirror, shoes, bag, and Mom are done. Floor is the tan path tile, tinted blue so morning feels cold. No second room.

| Spot | Asset |
| --- | --- |
| Floor | `assets/other_itemas/Tiles/Path_Middle.png`, modulate toward blue |
| Walking Arun | `assets/other_itemas/Player/Player.png` |
| Face when he talks | `assets/boy/Idle/frame-1.png` |
| Mom | Same player sheet, modulate a red shirt. One down-facing frame. |
| Window plant | Crop a pot from `assets/other_itemas/Outdoor decoration/Outdoor_Decor_Free.png` |
| Bed, mirror, shoes, bag, door | **draw** four tiny props. A colored square is allowed for the first playtest. |

| Lane | Do this |
| --- | --- |
| ART | Tint the floor, drop the plant, draw bed, mirror, shoes, and the empty bag. Mom is a recolor, not a new person. |
| CODE | Walls so he cannot leave the screen. Space on bed, mirror, shoes, bag, Mom, then the door. Door loads `scenes/school.tscn` only after those four. Lines are the house lines in `STORYBOARD.md`. |
| MUSIC | `assets/audio/calm.ogg` — quiet morning. A short `assets/audio/alarm.ogg` when the scene starts. |

## 3. School — `scenes/school.tscn`

Panels B1 to C5. He blanks the question, Kabir sits him back up, he answers, he carries three papers, he says one sentence about a picture, the bell sends him home.

**Idea.** One classroom. Board on the top wall, Ms. Das in front of it, three desks with one paper each, Kabir off to the side and hidden until the question starts. The picture for the creative task is the wooden house: one window lit, which matches his line "Somebody left, and the room stayed." Do not add a corridor. The door home is on the bottom wall and stays shut until the sentence lands.

| Spot | Asset |
| --- | --- |
| Floor | `assets/other_itemas/Tiles/Path_Middle.png`, left untinted |
| Ms. Das | Player sheet, modulate a blue shirt |
| Kabir | Player sheet, modulate a purple shirt. Hidden until the exam talk. |
| The picture she holds up | `assets/other_itemas/Outdoor decoration/House_1_Wood_Base_Blue.png` |
| Papers, board, desks | **draw.** Three identical paper sprites. One board. One desk, placed three times. |
| Fall | When the bar misses, play the "down" frame from `Player.png` if you can slice it. Face in the box switches to `assets/boy/Jump/Jump-fall.png`. On stand-up, face is `assets/boy/Jump/Jump-up.png`. |

| Lane | Do this |
| --- | --- |
| ART | Recolor the teacher and Kabir. Draw the board, one desk, one paper. Put the house picture on the board for the second task. |
| CODE | Exam talk, then the wide green bar. Miss goes grey and mash Space returns the same bar. Three papers, then the desk. Tighter bar for the picture. Door loads `scenes/roof.tscn` only after the sentence. Reuse `bar.tscn` and `fall.tscn`. Do not write a second minigame. |
| MUSIC | Keep `calm.ogg` or a drier school take of the same loop. `assets/audio/miss.ogg` on a bad press. `assets/audio/fall.ogg` while the screen is grey. `assets/audio/boing.ogg` when he stands. `assets/audio/success.ogg` when Ms. Das accepts the answer. |

## 4. Roof, evening — `scenes/roof.tscn`

Panels D1 to D3. He thinks about the lie, the freeze, and the phone. Then he opens it.

**Idea.** The roof of his own house, warmer than the morning. A low wall, one lamp, a lot of empty space. No Mom. He walks in, three thoughts play, then the phone appears in his hand or on the wall. One screen: PASSED. Not first. No rank and no percentage.

| Spot | Asset |
| --- | --- |
| Floor | `Path_Middle.png`, modulate toward dusk purple |
| Low wall | `assets/other_itemas/Tiles/Cliff_Tile.png` along the top |
| Lamp | Crop the lamp from `Outdoor_Decor_Free.png` |
| Phone | **draw** a small dark rectangle with the word PASSED. The pack has no phone. |
| Walking Arun | Same `Player.png` |

| Lane | Do this |
| --- | --- |
| ART | Dusk tint, cliff lip, lamp, and the phone screen. |
| CODE | On enter, play the three thought lines. Then Space on the phone. Then load `scenes/ending.tscn`. No bar on this scene. |
| MUSIC | Drop the school loop. `assets/audio/roof.ogg` almost empty. Cut it when the phone opens. |

## 5. Ending — `scenes/ending.tscn`

Panel D4. He sits. The card stays up.

**Idea.** No new place. His portrait, two sentences, the HC line. Space may return to the title. Nothing after that.

| Lane | Do this |
| --- | --- |
| ART | `assets/boy/Idle/frame-2.png` or frame-1, smaller than the title. |
| CODE | Card text, exactly: "He passed." and "Tomorrow he can tell Mom the truth." Plus "HC — Hack Club Haven". |
| MUSIC | Let `roof.ogg` finish or fade. No new track. |

## Do not put these in a scene

`Water_Tile`, `Beach_Tile`, `FarmLand_Tile`, `Grass_Middle`, `Chest.png`, `Bridge_Wood.png`, `Fences.png`, `Oak_Tree`, slime, skeleton, sheep, pig, cow, chicken, and `Player_Actions.png` (the tool swings). They fight the day or add a room you do not have time to build.

## Order for the next few hours

1. CODE: player walks on a path-tile floor in `house.tscn`.
2. ART: Mom recolor, empty bag, bed.
3. MUSIC: `calm.ogg` and `boing.ogg`.
4. CODE: school door, exam bar, fall, three papers.
5. ART: board, paper, phone.
6. CODE: roof thoughts and the ending card.
