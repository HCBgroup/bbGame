# School by 6pm

For the two of you who are coding this scene. Done at 6 means one thing: open the school, hold an arrow key, and the hallway never ends. You can turn around and it still never ends. Top and bottom walls stop you.

Not part of this goal: Mom, the exam, the sliding bar, the roof, the phone, music.

Open the **root** `project.godot` in Godot 4.7. Do not open `draft/`.

Do not edit the same file at the same time. Save, commit, and pull before you swap files.

## Split

| Who | Files only they edit | Done when |
| --- | --- | --- |
| You | `scenes/player.tscn`, `scripts/player.gd`, `scenes/school.tscn`, `scripts/school.gd` | Arrow keys move him, camera follows, three copies of the chunk jump forward forever |
| Aizel | `scenes/chunk.tscn` | One hallway piece, 480 wide and 160 tall, with a floor and two walls |

Aizel builds the piece. You duplicate it in code. Neither of you draws a giant map.

## What you are building

One chunk is a short corridor. The school keeps three chunks in a row. When you walk past the front one, the back one is moved to the front. When you walk back, the front one is moved to the back. The pieces are identical, so the jump is invisible. That is the whole "infinite" trick. Do not make a hundred rooms.

```
[ chunk ][ chunk ][ chunk ]
              ^
           player
walk right -> the left chunk hops to the right end
```

Floor tile: `res://assets/other_itemas/Tiles/Path_Middle.png` (16×16).
Walk sprite: `res://assets/other_itemas/Player/Player.png`, first frame only, region 16×16 at the top left. If that frame looks cut off, change 16 to 32. Do not use `assets/boy/` for the walking body. Those are portraits.

## 2:50–3:20 together

1. Both open the root project.
2. Aizel creates the folders by saving the scenes below. You create `scripts/`.
3. Agree the chunk is **480 by 160**. Do not change those numbers after 3:20.

## Aizel — `scenes/chunk.tscn`

1. New scene. Root node **Node2D**, rename it `Chunk`.
2. Add a **Sprite2D** named `Floor`. Texture `Path_Middle.png`. In the inspector turn on **Region**. Set the region to `x 0, y 0, w 16, h 16`. Scale it to `30` by `10` so it becomes 480×160. Position it at `(240, 80)` so the chunk starts at x=0.
3. Add a **StaticBody2D** named `TopWall`. Add a **CollisionShape2D** under it. Shape: **New RectangleShape2D**, size `480 x 16`. Put `TopWall` at `(240, 8)`.
4. Duplicate that wall. Rename it `BottomWall`. Put it at `(240, 152)`.
5. Add a **Marker2D** named `Door` at `(240, 140)`. No script. It only marks where a classroom can go later.
6. Save as `res://scenes/chunk.tscn`.
7. Press F6. You should see a tan strip with invisible walls. That is enough. Tell the other person the chunk is saved.

If the floor is a tiny square, the scale is wrong. It must be 30 by 10.

## You — player, then the school

### Player

`scenes/player.tscn` already exists. It is a `CharacterBody2D` with motion mode Floating. Keep that.

1. Add a **CollisionShape2D**. Rectangle, size about `14 x 14`.
2. Hide the old **AnimatedSprite2D** (the portrait is too big for a hallway).
3. Add a **Sprite2D**. Texture `Player.png`. Region on. Region `0, 0, 16, 16`.
4. Add a **Camera2D**. Turn **Enabled** on. Leave zoom at 1.
5. Detach any script if Godot complains, then attach a new script `res://scripts/player.gd`:

```gdscript
extends CharacterBody2D

const SPEED := 80.0

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * SPEED
	move_and_slide()
```

Arrow keys already drive `ui_left`, `ui_right`, `ui_up`, `ui_down`. Use those. Add WASD after 6 if you want.

### School

1. New scene. Root **Node2D**, rename `School`. Save as `res://scenes/school.tscn`.
2. Instance the player: drag `player.tscn` into the scene. Place him at `(240, 80)`.
3. Attach `res://scripts/school.gd` on the School root:

```gdscript
extends Node2D

const CHUNK_W := 480.0
const CHUNK_SCENE := preload("res://scenes/chunk.tscn")

@onready var player: CharacterBody2D = $Player
var chunks: Array[Node2D] = []

func _ready() -> void:
	for i in 3:
		var chunk := CHUNK_SCENE.instantiate()
		chunk.position = Vector2(i * CHUNK_W, 0)
		add_child(chunk)
		chunks.append(chunk)

func _physics_process(_delta: float) -> void:
	var left := chunks[0]
	var right := chunks[chunks.size() - 1]
	if player.global_position.x > right.position.x:
		left.position.x = right.position.x + CHUNK_W
		chunks.pop_front()
		chunks.append(left)
	elif player.global_position.x < left.position.x:
		right.position.x = left.position.x - CHUNK_W
		chunks.pop_back()
		chunks.push_front(right)
```

4. Project, Project Settings, Application, Run, Main Scene: `res://scenes/school.tscn`.
5. F5. Walk right for ten seconds. The hall should keep going. Walk left. Same thing. Walk into the top or bottom. You should stop.

The player node must be named `Player`. If the instance has another name, rename it.

## 5:10–5:45 if the hall already loops

Still no exam. One classroom, so the school is not only a tunnel.

1. Aizel duplicates `chunk.tscn` to `scenes/classroom.tscn` and moves the walls so there is a gap at the bottom center, about 32 pixels, in front of the `Door` marker.
2. You add an **Area2D** named `Door` on the first chunk only, in code, after the chunks exist, on `chunks[1]`, at the Door marker. `body_entered` sets a label "classroom later" or moves the player to `(240, 80)` inside an instanced `classroom.tscn` placed at `(0, 200)`, under the hall.
3. A second Area2D at the classroom door moves him back to `(240, 80)`.

If this is not fun by 5:30, stop. A looping hall is the 6pm game. A broken door is worse than no door.

## 5:45–6:00 both

Play it on both laptops. Fix only these:

- He walks through a wall: the wall has no CollisionShape2D, or the player has no CollisionShape2D.
- The hall ends: chunk width is not 480, or School is not the main scene.
- He blinks backward: you are moving the player instead of the chunk. Only the chunk's `position.x` changes.
- The floor has a gap: the chunk's floor is not 480 wide, or chunks are not placed `i * 480` apart.

Commit `scenes/player.tscn`, `scenes/chunk.tscn`, `scenes/school.tscn`, `scripts/player.gd`, and `scripts/school.gd`. Write "school hallway loops" in the message. Pull on the other laptop and press F5.
