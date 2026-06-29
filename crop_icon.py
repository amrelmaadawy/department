import sys
from PIL import Image

def crop_center(image_path, out_path, crop_factor=0.6):
    try:
        img = Image.open(image_path)
        width, height = img.size
        
        # Calculate new dimensions
        new_width = int(width * crop_factor)
        new_height = int(height * crop_factor)
        
        # Calculate coordinates for center crop
        left = (width - new_width) / 2
        top = (height - new_height) / 2
        right = (width + new_width) / 2
        bottom = (height + new_height) / 2
        
        # Crop the center of the image
        cropped = img.crop((left, top, right, bottom))
        
        # Resize back to 1024x1024 for high quality
        resized = cropped.resize((1024, 1024), Image.Resampling.LANCZOS)
        
        # Save optimized image
        resized.save(out_path, format="PNG")
        print(f"Successfully cropped and saved to {out_path}")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # We used 0.45 before which made it too big.
    # 0.75 should make it significantly smaller than 0.45 but still bigger than original (1.0).
    crop_center("assets/icons/launcher icon.png", "assets/icons/app_icon_cropped.png", 0.75)
