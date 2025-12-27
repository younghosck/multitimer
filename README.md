# Meditation Timer App

A minimalist Flutter meditation timer app optimized for older devices with clean iOS-style design.

## ✨ Features

- **Multiple Timers**: Create and manage unlimited meditation timers
- **Sequential Playback**: Play all timers in sequence (Phase 1)
- **Background Execution**: Timers continue running when app is minimized
- **Custom Sounds**: Choose from 5 meditation completion sounds
- **Color Tags**: Organize timers with 8 beautiful color options
- **Auto-Save**: All changes persist automatically
- **Clean UI**: Minimalist design inspired by iOS meditation apps

## 📱 Requirements

- **Android**: SDK 21+ (Android 5.0 Lollipop)
- **iOS**: 12.0+
- **Flutter**: SDK 3.0.0+

## 🚀 Getting Started

### 1. Clone & Install Dependencies

```bash
git clone <your-repo-url>
cd meditation_timer
flutter pub get
```

### 2. Add Audio Files

Add meditation sound files to `assets/sounds/` directory:
- `bell_soft.mp3`
- `bell_clear.mp3`
- `chime_gentle.mp3`
- `gong_deep.mp3`
- `singing_bowl.mp3`

See [AUDIO_SETUP.md](AUDIO_SETUP.md) for detailed instructions.

### 3. Run the App

```bash
flutter run
```

## 🏗️ Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/                        # Data models
├── providers/                     # Riverpod state management
├── screens/                       # UI screens
├── widgets/                       # Reusable widgets
└── services/                      # Business logic
```

## 🎯 Usage

### Creating a Timer
1. Tap the **+** button in the top-right
2. Select a color tag
3. Enter timer name (optional)
4. Set duration using the time picker
5. Choose completion sound
6. Tap **Done**

### Playing Timers
- **Individual**: Tap play button on any timer card
- **Sequential**: Tap the play button at top-left to play all timers in order

### Editing/Deleting
- **Edit**: Tap on a timer card
- **Delete**: Swipe left on timer card

## 🧪 Testing

See [walkthrough.md](walkthrough.md) for comprehensive testing checklist.

## 📦 Dependencies

- **flutter_riverpod**: State management
- **just_audio**: Audio playback
- **shared_preferences**: Data persistence
- **uuid**: Unique ID generation

## 🎨 Design

- **Style**: Minimalist Soft UI (Neumorphism-light)
- **Colors**: Soft pastel palette optimized for meditation
- **Performance**: Optimized for devices from 2018-2020 era

## 📝 License

MIT License - see LICENSE file for details

## 🤝 Contributing

Contributions welcome! Please feel free to submit a Pull Request.
