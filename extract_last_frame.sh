#!/bin/bash

# Usage: ./extract_last_frame.sh <input_video.mp4>
# Outputs: last_frame.jpg in the same directory

INPUT_VIDEO="$1"
if [ -z "$INPUT_VIDEO" ]; then
    echo "Error: Provide input MP4 file as argument."
    exit 1
fi

if [ ! -f "$INPUT_VIDEO" ]; then
    echo "Error: File '$INPUT_VIDEO' not found."
    exit 1
fi

# Get total number of frames
TOTAL_FRAMES=$(ffprobe -v error -select_streams v:0 -count_frames -show_entries stream=nb_frames -of csv=p=0 "$INPUT_VIDEO")

# Extract the last frame (frame index starts at 0, so select eq(n\,$(($TOTAL_FRAMES - 1))))
ffmpeg -i "$INPUT_VIDEO" -vf "select=eq(n\,$(($TOTAL_FRAMES - 1)))" -vframes 1 -y "last_frame.jpg"

echo "Last frame extracted to: last_frame.jpg"