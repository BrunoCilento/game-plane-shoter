# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Running the Game

```
love .
```

Requires [LÖVE 2D](https://love2d.org) installed. On Windows you can also drag the project folder onto `love.exe`.

No build step — all files are interpreted at runtime.

## Architecture

**Stack:** Lua + LÖVE 2D framework, using `lib/class.lua` for OOP and `lib/push.lua` for virtual resolution (432×243 rendered in a 1280×720 window).

**State machine pattern:** `src/StateMachine.lua` drives the game loop. All game scenes inherit from `src/states/BaseState.lua` and are registered in `main.lua` under the global `gStateMachine`. States: `TitleScreenState` → `CountdownState` → `PlayState` → `GameOverState` → `EnterHighScoreState` / `HighScoreState`.

**Entity lifecycle:** Entity classes (`Plane`, `Missile`, `Bomb`, `Block`, `Ground`) live in `src/`. They are instantiated inside `PlayState` and stored in Lua tables (`blocks_table`, `plane.missile_table`, `plane.bombs_table`). Each entity implements `update(dt)` and `render()`.

**Global constants** (defined in `main.lua`): `VIRTUAL_WIDTH`, `VIRTUAL_HEIGHT`, `WINDOW_WIDTH`, `WINDOW_HEIGHT`, `GROUND_LEVEL`, and font sizes (`gFonts`).

**Dependencies** are centralized in `src/Dependencies.lua` — add new `require` statements there.

**High scores** are persisted to `towerdestroyer.lst` in the LÖVE save directory via `love.filesystem`. Format: alternating name (3 chars) / score lines, 10 entries.

## Key Mechanics (PlayState)

- Plane moves horizontally and wraps: exits right → re-enters left, drops one `PLANE_HEIGHT` row, and accelerates by 5 px/s each pass.
- Weapons: `M` fires a missile (max 3 in flight, limited by `missile_ammo`); `SPACE` drops a bomb (max 2 in flight).
- Missiles inherit the plane's horizontal velocity and accelerate (`dx *= 1.01`). Bombs decelerate horizontally (`dx *= 0.989`) and fall under gravity.
- Collision is AABB via each entity's `collides(target)` method.
- Scoring: +1 per block hit; streak bonus `+floor(streak/5)` per hit; streak resets when a projectile exits without hitting.
- Game ends when the plane reaches `GROUND_LEVEL` or health reaches 0.

## Known Incomplete Areas

- `VictoryState` is referenced in `main.lua` but not implemented.
- `Ground.lua` methods reference `Block` instead of `Ground` (copy-paste bug).
- `graphics/` and `sounds/` directories are empty; the game uses colored rectangles and has no audio.
- `LevelMaker.lua` exists but `PlayState` spawns blocks directly via its own `spawnBlocks()` function instead.
