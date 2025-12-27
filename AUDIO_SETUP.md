# Audio Assets Setup

## Directory Structure
```
assets/
└── sounds/
    ├── bell_soft.mp3
    ├── bell_clear.mp3
    ├── chime_gentle.mp3
    ├── gong_deep.mp3
    └── singing_bowl.mp3
```

## How to Add Sound Files

1. **Find or Create Sound Files**:
   - Use royalty-free meditation sounds from sites like freesound.org, zapsplat.com
   - Recommended formats: MP3, AAC, or M4A
   - Keep files under 15MB each
   - Ideal duration: 3-10 seconds

2. **Place Files**:
   - Copy your sound files to `assets/sounds/` directory
   - Use the exact filenames listed above (or update `timer_model.dart` to match your filenames)

3. **Verify Registration**:
   - Files are already registered in `pubspec.yaml` under the `assets:` section
   - No additional configuration needed

## Temporary Testing

For initial testing without actual audio files, the app will gracefully handle missing files:
- A warning will be printed to console
- The app will not crash
- You can still test all other functionality

## Example Sound Sources

- **Bell Soft**: Gentle meditation bell
- **Bell Clear**: Clear, crisp bell tone
- **Chime Gentle**: Soft wind chime
- **Gong Deep**: Deep resonant gong
- **Singing Bowl**: Tibetan singing bowl sound
