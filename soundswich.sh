#!/bin/bash
Config="$HOME/soundswich/config"
CARDS=(
    "alsa_output.pci-0000_2d_00.3.analog-stereo"
    "alsa_output.pci-0000_2d_00.3.analog-stereo"
    "bluez_output.D8_25_6F_60_00_83.1"
)
OUTPUTS=(
    "analog-output-headphones"
    "analog-output-lineout"
    "a2dp-sink"
)
if [ "$1" = "-init" ];
then
    echo -e "0" > $Config
    exit
fi

if [ -f "$Config" ]; then
    MODE=$(sed -n '1p' $Config)
else
    echo "no config"
    exit
fi
len=$((${#OUTPUTS[@]}-1))
if [ $MODE -eq $len ]; then
    NEW_MODE=0
else
    ((NEW_MODE = $MODE+1))
fi

COMMAND=""

if [[ ${CARDS[$MODE]} != ${CARDS[$NEW_MODE]} ]]; then
    eval "pactl set-default-sink ${CARDS[$NEW_MODE]}"
    COMMAND+="pactl set-default-sink ${CARDS[$NEW_MODE]}\n"
fi

eval "pactl set-sink-port ${CARDS[$NEW_MODE]} ${OUTPUTS[$NEW_MODE]}"
COMMAND+="pactl set-sink-port ${CARDS[$NEW_MODE]} ${OUTPUTS[$NEW_MODE]}\n"

MODE=$NEW_MODE

echo "------------------------------------------------"
echo -e "executed\n${COMMAND}"
echo -e "$MODE" > $Config
