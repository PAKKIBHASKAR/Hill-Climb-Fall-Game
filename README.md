# Hill Climb Fall - A CLI Dice Game

## 🎮 About the Game

**Hill Climb Fall** is a simple two-player dice-based game implemented using Bash and the `dialog` utility for interactive UI. Players take turns rolling a dice to reach the top of the hill (position 10). However, if they exceed 10, they fall back to 0!

## 🛠 Features
- Play against a human or CPU.
- Interactive CLI-based UI using `dialog`.
- Coin toss to decide the starting player.
- Dice roll simulation with ASCII representation.
- Automatic logging of game progress.

## 📜 Rules
1. Players take turns rolling the dice.
2. The first player to reach **exactly 10** wins.
3. If a player overshoots 10, their position resets to 0.
4. The game starts with a coin toss: **Even → Player A starts, Odd → Player B starts.**

## 🚀 How to Run
### Prerequisites
- Linux/Unix-based system
- `dialog` package installed (Run `sudo apt install dialog` on Debian-based systems)

### Run the Game
```sh
chmod +x hill_climb_fall.sh
./hill_climb_fall.sh
```

## 🎲 Game Flow
1. Welcome screen with the hill illustration.
2. Choose between:
   - **Two Player Mode** (Play with a friend)
   - **Play Against CPU** (CPU as Player B)
3. Players enter their names.
4. Coin toss determines the starting player.
5. Players take turns rolling the dice by pressing `p`.
6. The game continues until one player reaches **exactly 10**.
7. The winner is announced and the game log is displayed.

## 🔄 Example Dice Roll Output
```
┌───────┐
│.●...●.│
│...●...│
│.●...●.│
└───────┘
Player A rolled a 5!
Current Position:
  A: 5
  B: 3
```

## 🏆 Winning Example
```
🏆 Player A wins! 🏆
```

## 📜 Game Log
The game progress is logged in `game_log.txt` with each dice roll.

## 🤖 Future Enhancements
- Add customizable board size.
- Introduce power-ups (e.g., skip turn, roll twice).
- Multiplayer support over SSH.

## 📜 License
This project is open-source and available under the MIT License.

Enjoy playing **Hill Climb Fall**! 🎲🚀

