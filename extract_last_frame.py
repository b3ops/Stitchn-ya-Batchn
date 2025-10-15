import sys
import torch
import torchvision.io as io
from PIL import Image
import numpy as np

# Usage: python extract_last_frame.py <input_video.mp4>
# Outputs: last_frame.jpg

if len(sys.argv) != 2:
    print("Error: Provide input MP4 file as argument.")
    sys.exit(1)

input_video = sys.argv[1]
if not torch.cuda.is_available():
    device = torch.device("cpu")
else:
    device = torch.device("cuda")

try:
    # Read video: returns video_tensor (T, H, W, C), audio, info
    video_tensor, _, info = io.read_video(input_video, pts_unit='sec')
    
    if video_tensor.shape[0] == 0:
        raise ValueError("No frames found in video.")
    
    # Get last frame (shape: H, W, C)
    last_frame = video_tensor[-1].permute(1, 2, 0).numpy()  # To HWC for PIL
    
    # Normalize if needed (assuming uint8 range 0-255)
    if last_frame.max() <= 1.0:
        last_frame = (last_frame * 255).astype(np.uint8)
    
    # Save as JPG
    img = Image.fromarray(last_frame)
    img.save('last_frame.jpg')
    
    print(f"Last frame extracted to: last_frame.jpg (Video info: {info['video_fps']} FPS, {info['video_duration']} sec)")
    
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)