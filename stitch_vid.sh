#!/bin/bash
# Usage: ./stitch_videos.sh video_list.txt output.mp4

LIST_FILE="$1"
OUTPUT="$2"
if [ -z "$LIST_FILE" ] || [ -z "$OUTPUT" ]; then
    echo "Error: Provide list.txt and output.mp4 as arguments."
    exit 1
fi

ffmpeg -f concat -safe 0 -i "$LIST_FILE" -c copy "$OUTPUT"
echo "Stitched video saved to: $OUTPUT"