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
    1: 'د',
    2: 'س',
    3: 'چ',
    4: 'پ',
    5: 'هـ',
    6: 'ش',
    7: 'ی',
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
              'دیاریکردنی دووبارەبوونەوە',
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Daily option
            _buildRadioTile(
              title: 'ڕۆژانە',
              subtitle: 'هەموو ڕۆژەکانی هەفتە',
              value: 'daily',
            ),
            const SizedBox(height: 8),

            // Weekdays option
            _buildRadioTile(
              title: 'ڕۆژانی ناوەڕاستی هەفتە',
              subtitle: 'دووشەممە تا هەینی',
              value: 'weekdays',
            ),
            const SizedBox(height: 8),

            // Weekends option
            _buildRadioTile(
              title: 'ڕۆژانی کۆتایی هەفتە',
              subtitle: 'شەممە و یەکشەممە',
              value: 'weekends',
            ),
            const SizedBox(height: 8),

            // Custom days option
            _buildRadioTile(
              title: 'ڕۆژانی تایبەت',
              subtitle: 'ڕۆژە دیاریکراوەکانی هەفتە هەڵبژێرە',
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
                        entry.value,
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
                    const SnackBar(content: Text('تکایە لانی کەم یەک ڕۆژ دیاری بکە.', style: TextStyle(fontFamily: 'Cairo'))),
                  );
                  return;
                }
                widget.onSaved(_selectedFrequency, _selectedDays);
                Navigator.pop(context);
              },
              child: const Text(
                'پەسەندکردن',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
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
                      fontFamily: 'Cairo',
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
                      fontFamily: 'Cairo',
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
