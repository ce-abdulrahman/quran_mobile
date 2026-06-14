import 'package:flutter/material.dart';

class FrequencyPicker extends StatefulWidget {
  final String initialFrequency;
  final List<int> initialCustomDays;
  final Function(String frequency, List<int> customDays) onSaved;

  const FrequencyPicker({
    super.key,
    required this.initialFrequency,
    required this.initialCustomDays,
    required this.onSaved,
  });

  @override
  State<FrequencyPicker> createState() => _FrequencyPickerState();
}

class _FrequencyPickerState extends State<FrequencyPicker> {
  late String _selectedFrequency;
  late List<int> _selectedDays;

  final Map<int, String> _weekdaysMap = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.initialFrequency;
    _selectedDays = List<int>.from(widget.initialCustomDays);
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            Text(
              'Select Frequency',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Daily option
            _buildRadioTile(
              title: 'Daily',
              subtitle: 'Every day of the week',
              value: 'daily',
            ),
            const SizedBox(height: 8),

            // Weekdays option
            _buildRadioTile(
              title: 'Weekdays',
              subtitle: 'Monday through Friday',
              value: 'weekdays',
            ),
            const SizedBox(height: 8),

            // Weekends option
            _buildRadioTile(
              title: 'Weekends',
              subtitle: 'Saturday and Sunday',
              value: 'weekends',
            ),
            const SizedBox(height: 8),

            // Custom days option
            _buildRadioTile(
              title: 'Custom Days',
              subtitle: 'Select specific days of the week',
              value: 'custom',
            ),

            if (_selectedFrequency == 'custom') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _weekdaysMap.entries.map((entry) {
                  final isSelected = _selectedDays.contains(entry.key);
                  return GestureDetector(
                    onTap: () => _toggleDay(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.primaryColor
                            : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? theme.primaryColor
                              : (isDark ? Colors.white24 : Colors.black12),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        entry.value.substring(0, 1),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                if (_selectedFrequency == 'custom' && _selectedDays.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select at least one day.')),
                  );
                  return;
                }
                widget.onSaved(_selectedFrequency, _selectedDays);
                Navigator.pop(context);
              },
              child: const Text(
                'Confirm Selection',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String subtitle,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedFrequency == value;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFrequency = value;
          if (value == 'custom' && _selectedDays.isEmpty) {
            _selectedDays = [1, 2, 3, 4, 5]; // Default weekdays
          }
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withValues(alpha: 0.08)
              : (isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.01)),
          border: Border.all(
            color: isSelected ? theme.primaryColor : (isDark ? Colors.white10 : Colors.black12),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.primaryColor
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedFrequency,
              activeColor: theme.primaryColor,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedFrequency = val;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
