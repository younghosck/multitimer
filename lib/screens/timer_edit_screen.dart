import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/timer_model.dart';
import '../providers/timer_list_provider.dart';
import '../widgets/color_picker_row.dart';
import '../widgets/sound_selector_button.dart';
import '../widgets/sound_selection_sheet.dart';

/// Screen for creating or editing a meditation timer
class TimerEditScreen extends ConsumerStatefulWidget {
  final String? timerId; // null for new timer, non-null for editing

  const TimerEditScreen({super.key, this.timerId});

  @override
  ConsumerState<TimerEditScreen> createState() => _TimerEditScreenState();
}

class _TimerEditScreenState extends ConsumerState<TimerEditScreen> {
  late TextEditingController _nameController;
  late Color _selectedColor;
  late String _selectedSound;
  late Duration _selectedDuration;

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing timer data or defaults
    if (widget.timerId != null) {
      final timer = ref.read(timerListProvider).firstWhere(
        (t) => t.id == widget.timerId,
      );
      _nameController = TextEditingController(text: timer.name);
      _selectedColor = timer.color;
      _selectedSound = timer.soundFileName;
      _selectedDuration = timer.duration;
    } else {
      _nameController = TextEditingController();
      _selectedColor = TimerColors.softBlue;
      _selectedSound = MeditationSounds.bellSoft;
      _selectedDuration = const Duration(minutes: 20);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveTimer() {
    final timerId = widget.timerId ?? const Uuid().v4();
    
    final timer = MeditationTimer(
      id: timerId,
      name: _nameController.text.trim(),
      color: _selectedColor,
      duration: _selectedDuration,
      soundFileName: _selectedSound,
    );

    if (widget.timerId != null) {
      ref.read(timerListProvider.notifier).updateTimer(timerId, timer);
    } else {
      ref.read(timerListProvider.notifier).addTimer(timer);
    }

    Navigator.pop(context);
  }

  void _showSoundPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SoundSelectionSheet(
        currentSound: _selectedSound,
        onSoundSelected: (sound) {
          setState(() {
            _selectedSound = sound;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          widget.timerId == null ? 'New Timer' : 'Edit Timer',
          style: TextStyle(
            color: Colors.grey[900],
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveTimer,
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Color picker
            ColorPickerRow(
              selectedColor: _selectedColor,
              onColorSelected: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Name input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _nameController,
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: 'Enter timer name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                  counterText: '',
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Time picker
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms,
                initialTimerDuration: _selectedDuration,
                onTimerDurationChanged: (duration) {
                  setState(() {
                    _selectedDuration = duration;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Sound selector
            SoundSelectorButton(
              selectedSound: _selectedSound,
              onTap: _showSoundPicker,
            ),
          ],
        ),
      ),
    );
  }
}
