#!/bin/bash

# Function to roll the dice
function roll_dice() {
    echo $(( (RANDOM % 6) + 1 ))
}

# Function to calculate sum
function sum_array() {
    local arr=("$@")
    local sum=0
    for num in "${arr[@]}"; do
        ((sum += num))
    done
    echo $sum
}

# Display welcome screen
dialog --title "🎮 Welcome!" --msgbox "🚩🚩🚩 Hill Climb Fall 🚩🚩🚩\n\nPress OK to start the game!" 10 40

# Initialize player positions
declare -a a=()
declare -a b=()
i=0
sum_a=0
sum_b=0
log_file="game_log.txt"

# Reset log file
echo "Game Start - $(date)" > $log_file

# Main game loop
while ((sum_a != 10 && sum_b != 10)); do
    if (( i % 2 == 0 )); then
        player="A"
        sum_val=$sum_a
    else
        player="B"
        sum_val=$sum_b
    fi

    # Show current status
    dialog --title "📊 Game Status" --msgbox "Player A: $sum_a\nPlayer B: $sum_b\n\n$player's turn!" 10 40

    # Ask player to roll the dice
    ch=$(dialog --inputbox "🎲 $player's turn - Enter 'p' to roll the dice:" 10 40 3>&1 1>&2 2>&3)

    if [[ "$ch" == "p" ]]; then
        throw=$(roll_dice)
        
        # Store dice roll
        if [[ "$player" == "A" ]]; then
            a+=($throw)
            sum_a=$(sum_array "${a[@]}")
        else
            b+=($throw)
            sum_b=$(sum_array "${b[@]}")
        fi

        # Show dice roll result
        dialog --title "🎲 Dice Roll" --msgbox "$player rolled a $throw!\n\nCurrent Position:\nA: $sum_a\nB: $sum_b" 10 40
        
        # Check if the player overshot 10
        if [[ "$player" == "A" && $sum_a -gt 10 ]]; then
            dialog --title "Oops! 🔄" --msgbox "Player A exceeded 10! Resetting to 0." 10 40
            a=()
            sum_a=0
        elif [[ "$player" == "B" && $sum_b -gt 10 ]]; then
            dialog --title "Oops! 🔄" --msgbox "Player B exceeded 10! Resetting to 0." 10 40
            b=()
            sum_b=0
        fi

        # Save the status to the log file
        echo "Player $player rolled $throw | A: $sum_a | B: $sum_b" >> $log_file
        ((i += 1))
    fi
done

# Declare winner
if ((sum_a == 10)); then
    dialog --title "🎉 Winner!" --msgbox "🏆 Player A wins! 🏆" 10 40
    echo "🏆 Player A wins!" >> $log_file
else
    dialog --title "🎉 Winner!" --msgbox "🏆 Player B wins! 🏆" 10 40
    echo "🏆 Player B wins!" >> $log_file
fi

# Show game log
dialog --title "📜 Game Summary" --textbox "$log_file" 15 50

