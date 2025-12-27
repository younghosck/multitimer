# Play All 디버그 가이드

## 🔍 문제 진단

사용자가 추가한 타이머가 Play All에서 실행되지 않는다고 보고했습니다.

## 🛠️ 추가된 디버그 로그

### HomeScreen에서 (Play All 버튼 클릭 시)
```
====================================
🎬 HomeScreen: Play All button pressed
   Timers in list: 3
   Timer 0: Morning Session (0:05:00)
   Timer 1: Afternoon Break (0:10:00)
   Timer 2: Evening Meditation (0:15:00)
   Timer IDs: [id-1, id-2, id-3]
   Calling startSequentialPlayback()...
====================================
```

### ActiveTimerProvider에서 (Sequential 시작 시)
```
🎬 Starting Sequential Playback
   Timer IDs: [id-1, id-2, id-3]
▶️ Starting first timer: Morning Session (0:05:00)
   State updated, calling _startCountdown()...
```

### 카운트다운 중
```
🔄 Starting countdown for timer: id-1
   Initial remaining time: 0:05:00
   Playback mode: PlaybackMode.sequential
⏱️ Timer id-1: 4:59
⏱️ Timer id-1: 4:58
...
```

## 📋 테스트 체크리스트

### 1단계: 앱 실행 및 타이머 생성
```bash
flutter run -d <device> --verbose
```

1. ✅ 앱이 정상적으로 시작되는가?
2. ✅ + 버튼을 눌러 타이머 3개 생성
   - 타이머 1: 10초
   - 타이머 2: 10초
   - 타이머 3: 10초

### 2단계: Play All 버튼 클릭

1. Play All 버튼 (▶️) 클릭
2. **콘솔 확인**

**예상 로그 순서:**
```
====================================
🎬 HomeScreen: Play All button pressed
   Timers in list: 3
   ... (타이머 정보)
====================================
🎬 Starting Sequential Playback
   Timer IDs: [...]
▶️ Starting first timer: ...
🔄 Starting countdown for timer: ...
⏱️ Timer ...: 0:09
⏱️ Timer ...: 0:08
```

### 3단계: 문제 패턴 확인

#### 패턴 A: "Timers in list: 0"
```
🎬 HomeScreen: Play All button pressed
   Timers in list: 0  ← 문제!
❌ Cannot start: No timers in list
```

**원인:** 타이머가 실제로 저장되지 않음  
**해결:** `timerListProvider`의 persistence 확인

#### 패턴 B: HomeScreen 로그만 있고 Sequential 로그 없음
```
🎬 HomeScreen: Play All button pressed
   Timers in list: 3
   ... (타이머 정보)
   Calling startSequentialPlayback()...
====================================
(아무것도 없음)
```

**원인:** `activeTimerProvider.notifier`가 호출되지 않음  
**해결:** Provider 연결 확인

#### 패턴 C: Sequential 시작했지만 카운트다운 없음
```
🎬 Starting Sequential Playback
   Timer IDs: [id-1, id-2, id-3]
▶️ Starting first timer: Morning (0:00:10)
   State updated, calling _startCountdown()...
(카운트다운 로그 없음)
```

**원인:** `_startCountdown()`이 호출되지 않거나 Timer.periodic이 작동하지 않음  
**해결:** Timer 생성 로직 확인

#### 패턴 D: 첫 타이머만 실행되고 다음으로 넘어가지 않음
```
✅ Timer id-1 COMPLETED!
🎯 _onTimerComplete called
   Current timer: id-1
   Playback mode: PlaybackMode.sequential
   Queue: [id-1, id-2, id-3]
   Current index in queue: 0
   Total timers in queue: 3
🔔 Playing completion sound: bell_soft.mp3
(다음 타이머 시작 로그 없음)
```

**원인:** 다음 타이머를 찾지 못함  
**해결:** `timerList.firstWhere` 실패 - timer ID 불일치

## 🎯 디버깅 단계별 가이드

### 상황 1: 타이머가 UI에 보이지만 Play All 시 0개

**명령어:**
```bash
# 앱 재시작
flutter run -r
```

**확인사항:**
1. 타이머를 새로 추가한 후 즉시 Play All 시도
2. 로그에서 "Timers in list" 숫자 확인

**예상 원인:**
- `watch` vs `read` 불일치
- Provider가 올바르게 notify하지 않음

### 상황 2: 타이머는 인식하지만 실행되지 않음

**확인사항:**
1. `startSequentialPlayback` 로그 확인
2. Timer IDs가 올바른지 확인
3. 첫 타이머를 찾을 수 있는지 확인

**예상 원인:**
- Timer ID 불일치
- `timerListProvider`에 타이머는 있지만 ID가 다름

### 상황 3: 첫 타이머만 실행되고 멈춤

**확인사항:**
1. "✅ Timer COMPLETED!" 로그 나오는지
2. "_onTimerComplete called" 로그 나오는지
3. "➡️ Moving to next timer" 로그 나오는지

**예상 원인:**
- State의 `playbackMode`가 리셋됨
- Queue가 손실됨
- 다음 타이머를 찾지 못함

## 🚀 Hot Reload로 디버깅

앱 실행 중에 코드 수정 후:
```bash
# 터미널에서 'r' 입력 (hot reload)
r

# 또는 'R' (hot restart - state 초기화)
R
```

## 📊 성공 시나리오

타이머 3개 (각 10초)를 추가하고 Play All을 누르면:

```
====================================
🎬 HomeScreen: Play All button pressed
   Timers in list: 3
   Timer 0: Test 1 (0:00:10)
   Timer 1: Test 2 (0:00:10)
   Timer 2: Test 3 (0:00:10)
   Timer IDs: [uuid-1, uuid-2, uuid-3]
   Calling startSequentialPlayback()...
====================================
🎬 Starting Sequential Playback
   Timer IDs: [uuid-1, uuid-2, uuid-3]
▶️ Starting first timer: Test 1 (0:00:10)
   State updated, calling _startCountdown()...
🔄 Starting countdown for timer: uuid-1
⏱️ Timer uuid-1: 0:09
⏱️ Timer uuid-1: 0:08
... (10 ticks)
⏱️ Timer uuid-1: 0:00
✅ Timer uuid-1 COMPLETED!
🎯 _onTimerComplete called
➡️ Moving to next timer: uuid-2 (index 1)
🔄 Starting countdown for timer: uuid-2
⏱️ Timer uuid-2: 0:09
... (10 ticks)
✅ Timer uuid-2 COMPLETED!
➡️ Moving to next timer: uuid-3 (index 2)
... (마지막 타이머)
✅ Timer uuid-3 COMPLETED!
🏁 Reached end of queue
🛑 Resetting to idle state
```

**총 소요 시간:** ~30초

---

## 다음 단계

1. **앱 실행**: `flutter run`
2. **타이머 생성**: 10초짜리 3개
3. **Play All 클릭**
4. **콘솔 로그 확인**
5. **위 패턴 중 어디에 해당하는지 확인**
6. **로그 공유**

로그를 보내주시면 정확한 문제를 파악할 수 있습니다!
