import 'package:flutter/material.dart';
import '../../../core/models/reminder_model.dart';
import 'frequency_picker.dart';

class ReminderTimeCard extends StatelessWidget {
  final ReminderModel reminder;
  final bool masterEnabled;
  final Function(bool enabled) onToggle;
  final Function(String time) onTimeChanged;
  final Function(String frequency, List<int> customDays) onFrequencyChanged;

  const ReminderTimeCard({
    super.key,
    required this.reminder,
    required this.masterEnabled,
    required this.onToggle,
    required this.onTimeChanged,
    required this.onFrequencyChanged,
  });

  String _formatFrequencyLabel(String freq, List<int> days) {
    switch (freq.toLowerCase()) {
      case 'daily':
        return 'Daily';
      case 'weekdays':
        return 'Weekdays (Mon-Fri)';
      case 'weekends':
        return 'Weekends (Sat-Sun)';
      case 'custom':
        if (days.isEmpty) return 'Select Days';
        final Map<int, String> dayNames = {
          1: 'Mon', 2: 'Tue', 3: 'Wed', 4: 'Thu', 5: 'Fri', 6: 'Sat', 7: 'Sun'
        };
        final sorted = List<int>.from(days)..sort();
        return sorted.map((d) => dayNames[d] ?? '').join(', ');
      default:
        return freq;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final parts = reminder.scheduledTime.split(':');
    final initialHour = parts.isNotEmpty ? (int.tryParse(parts[0]) ?? 8) : 8;
    final initialMinute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedHour = picked.hour.toString().padLeft(2, '0');
      final formattedMinute = picked.minute.toString().padLeft(2, '0');
      onTimeChanged('$formattedHour:$formattedMinute');
    }
  }

  void _showFrequencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FrequencyPicker(
        initialFrequency: reminder.frequency,
        initialCustomDays: reminder.customDays,
        onSaved: onFrequencyChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Determine card state (active if both master toggle and item toggle are enabled)
    final isActive = masterEnabled && reminder.enabled;

    // Custom coloring based on metadata
    final metadataColor = reminder.metadata != null && reminder.metadata!['color'] != null
        ? int.tryParse((reminder.metadata!['color'] as String).replaceFirst('#', '0xFF'))
        : null;
    final accentColor = metadataColor != null ? Color(metadataColor) : theme.primaryColor;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: masterEnabled ? 1.0 : 0.5,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isActive 
                ? accentColor.withValues(alpha: 0.3)
                : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
            width: isActive ? 2.0 : 1.0,
          ),
        ),
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isActive 
                          ? accentColor.withValues(alpha: 0.12)
                          : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      reminder.icon,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reminder.body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Toggle
                  Switch(
                    value: reminder.enabled,
                    activeThumbColor: accentColor,
                    onChanged: masterEnabled ? onToggle : null,
                  ),
                ],
              ),
            ),
            
            // Sub-configurations visible when enabled
            if (reminder.enabled && masterEnabled) ...[
              const Divider(height: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Time selector
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.02),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_filled, size: 18, color: accentColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? Colors.white38 : Colors.black38,
                                      ),
                                    ),
                                    Text(
                                      reminder.scheduledTime,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Frequency selector
                    Expanded(
                      child: InkWell(
                        onTap: () => _showFrequencyPicker(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.02),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.repeat, size: 18, color: accentColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Frequency',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? Colors.white38 : Colors.black38,
                                      ),
                                    ),
                                    Text(
                                      _formatFrequencyLabel(reminder.frequency, reminder.customDays),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
