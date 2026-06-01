# Tower Destroyer

A plane shooter game built with Lua and LÖVE 2D. My first game — started from scratch and continuously improved with the help of [Claude Code](https://claude.ai/code).

The goal is simple: fly your plane across the screen, drop bombs and fire missiles to destroy as many blocks as possible before hitting the ground.

---

## How to Play

| Key       | Action              |
|-----------|---------------------|
| `SPACE`   | Drop a bomb         |
| `M`       | Fire a missile      |
| `P`       | Pause / unpause     |

- The plane flies automatically from left to right.
- Each time it exits the right edge, it re-enters from the left **one row lower** and gains speed.
- The game ends when the plane reaches the ground or your health runs out.
- Build a streak by hitting consecutive blocks — bonus points per hit after every 5 in a row.

---

## Weapons

**Bombs** — fall under gravity and drift with the plane's momentum. Max 2 in the air at once.

**Missiles** — fire horizontally and accelerate over time. Limited ammo (shown on screen). Max 3 in the air at once.

---

## Scoring

- +1 point per block destroyed
- +bonus for streaks: `floor(streak / 5)` extra points per hit
- Streak resets when a projectile exits the screen without hitting anything

Top 10 scores are saved between sessions.

---

## Running the Game

Requires [LÖVE 2D](https://love2d.org) (version 11+).

```bash
love .
```

On Windows you can also drag the project folder onto `love.exe`.

No build step — all files are plain Lua interpreted at runtime.

---

## Project Structure

```
plane-2/
├── main.lua              # Entry point, LÖVE callbacks, high score I/O
├── src/
│   ├── Dependencies.lua  # Central require list
│   ├── StateMachine.lua  # Drives the game loop between screens
│   ├── AABB.lua          # Shared collision detection (axis-aligned bounding box)
│   ├── Plane.lua         # Player entity
│   ├── Missile.lua       # Missile projectile
│   ├── Bomb.lua          # Bomb projectile
│   ├── Block.lua         # Destructible block
│   ├── Ground.lua        # Ground entity
│   ├── LevelMaker.lua    # Level generation utilities
│   └── states/           # One file per game screen
│       ├── TitleScreenState.lua
│       ├── CountdownState.lua
│       ├── PlayState.lua
│       ├── GameOverState.lua
│       ├── EnterHighScoreState.lua
│       └── HighScoreState.lua
├── lib/
│   ├── class.lua         # OOP library (hump)
│   └── push.lua          # Virtual resolution (432×243 in a 1280×720 window)
├── fonts/
│   └── font.ttf
├── spec/                 # Automated tests (busted)
│   ├── AABB_spec.lua
│   ├── StateMachine_spec.lua
│   └── collides_spec.lua
└── assets/               # Graphics and sounds (in progress)
```

---

## Running Tests

Tests use the [busted](https://lunarmodules.github.io/busted/) framework and run outside the LÖVE runtime.

```powershell
$env:PATH = "$env:USERPROFILE\scoop\shims;$env:USERPROFILE\AppData\Roaming\luarocks\bin;" + $env:PATH
busted .
```

---

## Tech Stack

- **Language:** Lua 5.4
- **Framework:** [LÖVE 2D](https://love2d.org)
- **OOP:** [hump class](https://github.com/vrld/hump)
- **Virtual resolution:** [push](https://github.com/Ulydev/push)
- **Tests:** [busted](https://lunarmodules.github.io/busted/)

---

## About

This is my first game. I'm not a developer — I'm a game enthusiast learning by doing, through the [CS50 Introduction to Game Development](https://cs50.harvard.edu/games/) course. The initial version was built by hand; I've been using Claude Code to help refactor, add tests, and improve the code structure as I learn.
