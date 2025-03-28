#!/bin/bash

# Function to roll the dice
function roll_dice() {
    echo $(( (RANDOM % 6) + 1 ))
}

# Function to calculate sum
function sum_array() {
    local arr=($@)
    local sum_arr=0
    for num in "${arr[@]}"; do
        ((sum_arr += num))
    done
    echo $sum_arr
}



function print_dice() {
    case $1 in
        1)
            echo "┌───────┐
│.......│
│...●...│
│.......│
└───────┘"
            ;;
        2)
            echo "┌───────┐
│.●.....│
│.......│
│.....●.│
└───────┘"
            ;;
        3)
            echo "┌───────┐
│.●.....│
│...●...│
│.....●.│
└───────┘"
            ;;
        4)
            echo "┌───────┐
│.●...●.│
│.......│
│.●...●.│
└───────┘"
            ;;
        5)
            echo "┌───────┐
│.●...●.│
│...●...│
│.●...●.│
└───────┘"
            ;;
        6)
            echo "┌───────┐
│.●...●.│
│.●...●.│
│.●...●.│
└───────┘"
            ;;
    esac
}




hill="............................................._⛳_
.........................................___|...|
.....................................___|.......|
................................____|...........|
...........................____|................|
..........................|_____________________|"


# Welcome screen
dialog --title "🎮 Welcome!" --msgbox "       	 			🚩🚩🚩 Hill Climb Fall 🚩🚩🚩\n\n$hill \n\n       					Press OK to start the game!" 15 60

# Choose game mode
MODE=$(dialog --title "Choose Game Mode" --menu "Select mode:" 10 40 2 \
    "1" "Two Player Mode" \
    "2" "Play Against CPU" 3>&1 1>&2 2>&3)


# Get Player A's Name
A=$(dialog --title "Enter Player A's Name" --inputbox "🎮 Enter name for Player A:" 10 40 3>&1 1>&2 2>&3)



if [[ "$MODE" == "1" ]]; then
    # Two Player Mode - Get Player B's Name
    B=$(dialog --title "Enter Player B's Name" --inputbox "🎮 Enter name for Player B:" 10 40 3>&1 1>&2 2>&3)
   
else
    # Single Player Mode - Player B is CPU
    B="CPU"
fi


# Toss to decide who starts
while true; do
    toss_choice=$(dialog --title "🎲 Coin Toss" --inputbox "Press 'f' to flip the coin:" 10 40 3>&1 1>&2 2>&3)

    if [[ "$toss_choice" == "f" ]]; then
        toss=$(roll_dice)
        break
    fi
    dialog --title "❌ Invalid Input" --msgbox "Please press 'f' to flip the coin!" 10 40
done

dialog --title "Toss Condition" --msgbox "$A starts if even number on dice , $B starts if odd number on dice !!" 10 40

if (( toss % 2 == 0 )); then
    starter=$A
    i=0
else
    starter=$B
    i=1
fi

dialog --title "🎲 Coin Toss Result" --msgbox "Toss result: $toss\n\nSo $starter starts the game!" 10 40

# Initialize player positions
declare -a a=()
declare -a b=()
sum_a=0
sum_b=0
log_file="game_log.txt"


# Reset log file
echo "Game Start - $(date)" > $log_file


# Main game loop
while (( sum_a != 10 && sum_b != 10 )); do
    if (( i % 2 == 0 )); then
        player=$A
        sum_val=$sum_a
    else
        player=$B
        sum_val=$sum_b
    fi


    if [[ "$player" == "CPU" ]]; then
        # CPU automatically rolls the dice
        throw=$(roll_dice)
        sleep 1  # Simulate CPU thinking
        dialog --title "🎮 CPU's Turn" --msgbox "🤖 CPU is rolling the dice..." 10 40
    else
        ch=$(dialog --title "🎮 $player's Turn - Hill Climb Fall" --inputbox "📊 **Game Status:**\n\nPlayer $A: $sum_a\nPlayer $B: $sum_b\n\n🎲 $player's Turn!\nEnter 'p' to roll the dice:" 15 50 3>&1 1>&2 2>&3)
	if [[ "$ch" == "p" ]]; then
            throw=$(roll_dice)
        else
            continue
        fi
    fi



    # Store dice roll
    if [[ "$player" == "$A" ]]; then
	    a+=($throw)
            sum_a=$(sum_array "${a[@]}")
    else
	    b+=($throw)
            sum_b=$(sum_array "${b[@]}")
    fi
        

    dice_face=$(print_dice $throw)

    dialog --title "🎲 Dice Roll" --msgbox "$(printf "\n  $player rolled a $throw!  \n\n%s\n\nCurrent Position:\n  $A: $sum_a\n  $B: $sum_b\n" "$dice_face")" 20 40



    # Check if the player overshot 10
    if [[ "$player" == "$A" && $sum_a -gt 10 ]]; then
            dialog --title "Oops! 🔄" --msgbox "Player $A exceeded 10! Resetting to 0." 10 40
            a=()
            sum_a=0
    elif [[ "$player" == "$B" && $sum_b -gt 10 ]]; then
            dialog --title "Oops! 🔄" --msgbox "Player $B exceeded 10! Resetting to 0." 10 40
            b=()
            sum_b=0
     fi

     # Save the status to the log file
     echo "Player $player rolled $throw | $A: $sum_a | $B: $sum_b" >> $log_file

        ((i += 1))

done

# Declare winner
if ((sum_a == 10)); then
    dialog --title "🎉 Winner!" --msgbox "🏆 Player $A wins! 🏆" 10 40
    echo "🏆 Player $A wins!" >> $log_file
else
    dialog --title "🎉 Winner!" --msgbox "🏆 Player $B wins! 🏆" 10 40
    echo "🏆 Player $B wins!" >> $log_file
fi

dialog --title "📜 Game Summary" --textbox "$log_file" 15 80
