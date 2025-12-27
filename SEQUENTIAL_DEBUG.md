# Sequential Playback Debug Guide

## Debug Logs Added

The following debug logs have been added to track the sequential playback chain:

### 1. When Starting Sequential Playback
```
🎬 Starting Sequential Playback
   Timer IDs: [timer-1, timer-2, timer-3]
▶️ Starting first timer: Timer Name (0:05:00)
   State updated, calling _startCountdown()...
```

### 2. During Countdown
```
🔄 Starting countdown for timer: timer-1
   Initial remaining time: 0:05:00
   Playback mode: PlaybackMode.sequential
⏱️ Timer timer-1: 4:59
⏱️ Timer timer-1: 4:58
...
```

### 3. When Timer Completes
```
✅ Timer timer-1 COMPLETED!
🎯 _onTimerComplete called
   Current timer: timer-1
   Playback mode: PlaybackMode.sequential
   Queue: [timer-1, timer-2, timer-3]
   Current index in queue: 0
   Total timers in queue: 3
🔔 Playing completion sound: bell_soft.mp3
➡️ Moving to next timer: timer-2 (index 1)
   Next timer duration: 0:10:00
   Next timer name: Timer 2
✨ State updated, starting countdown for next timer...
```

### 4. When All Timers Complete
```
🏁 Reached end of queue (index: 2, length: 3)
🛑 Resetting to idle state
```

## How to Test

1. Run the app in debug mode:
```bash
flutter run -d chrome --verbose
```

2. Create 3 short timers (e.g., 10 seconds each)

3. Tap "Play All"

4. Watch the console output for the debug logs

## Common Issues & What to Look For

### Issue 1: Chain Doesn't Start
**Look for:**
```
❌ Cannot start: timer list is empty
```
or
```
❌ ERROR: Could not find first timer
```

**Fix:** Make sure timers exist in the list

### Issue 2: First Timer Plays But Chain Stops
**Look for:**
```
🔴 Not in sequential mode or queue is empty
```

**Cause:** The state might not be preserving `playbackMode` or `queuedTimerIds`

### Issue 3: Timer Never Completes
**Look for:** Missing countdown logs after start

**Cause:** `_startCountdown()` might not be called or timer is cancelled

### Issue 4: Sound Errors
**Look for:**
```
⚠️ Could not find timer to play sound
```

**Cause:** Audio files missing or timer not found

## Testing Sequential Playback

Create a minimal test case:

1. **Create 3 timers:**
   - Timer 1: 5 seconds
   - Timer 2: 5 seconds  
   - Timer 3: 5 seconds

2. **Expected console output:**
```
🎬 Starting Sequential Playback
   Timer IDs: [id-1, id-2, id-3]
▶️ Starting first timer: Timer 1 (0:00:05)
🔄 Starting countdown for timer: id-1
⏱️ Timer id-1: 0:04
⏱️ Timer id-1: 0:03
⏱️ Timer id-1: 0:02
⏱️ Timer id-1: 0:01
✅ Timer id-1 COMPLETED!
🎯 _onTimerComplete called
➡️ Moving to next timer: id-2 (index 1)
🔄 Starting countdown for timer: id-2
⏱️ Timer id-2: 0:04
... (continues through all 3 timers)
🏁 Reached end of queue
🛑 Resetting to idle state
```

3. **Total time:** Should take ~15 seconds

## If Chain Still Breaks

Check these in order:

1. **Timer list is populated:**
   - Debug: Print `timerList.length` in `_onTimerComplete`

2. **State persistence:**
   - Debug: Print entire `state` object at each step

3. **Timer IDs match:**
   - Debug: Compare `queuedTimerIds` with actual timer IDs from `timerListProvider`

4. **No exceptions thrown:**
   - Wrap critical sections in try-catch and log errors

## Reverting Debug Logs

To remove logs in production:
```dart
// Replace all debugPrint calls with:
if (kDebugMode) {
  debugPrint(...);
}
```
