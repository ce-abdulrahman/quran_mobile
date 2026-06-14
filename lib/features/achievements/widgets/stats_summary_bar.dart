import 'package:flutter/material.dart';
import '../../../core/models/achievement_model.dart';

class StatsSummaryBar extends StatelessWidget {
  final AchievementSummaryModel summary;
  final int rareCount;

  const StatsSummaryBar({
    super.key,
    required this.summary,
    required this.rareCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: '${summary.totalEarned}/${summary.totalAvailable}',
            label: 'دەستکەوتە',
            icon: '🏆',
          ),
          _Divider(),
          _StatItem(
            value: '${summary.completionPct.toStringAsFixed(0)}%',
            label: 'تەواوکردن',
            icon: '📊',
          ),
          _Divider(),
          _StatItem(
            value: '$rareCount',
            label: 'نادر',
            icon: '💎',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _StatItem({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: Colors.white12);
  }
}
